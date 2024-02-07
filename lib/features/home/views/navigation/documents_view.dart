import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/dialogs.dart';
import 'package:prosto_doc/core/helpers/documents_scaffold.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';
import 'package:prosto_doc/core/models/document_model.dart';
import 'package:prosto_doc/core/models/downloaded_document.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/current_document_view.dart';

class DocumentsView extends StatefulWidget {
  const DocumentsView({super.key});

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  List<Item> documents = [];
  List<UserModel> clients = [];
  List<Map<String, dynamic>> fields = [];

  @override
  void initState() {
    getDocuments();
    super.initState();
  }

  downloadDocument(Item item) async {
    int? clientId = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return clientList();
      },
    );
    print(clientId);
    if (clientId != null) {
      fields = [];
      for (var element in item.fields) {
        // ignore: use_build_context_synchronously
        await confirmDialog(
          context: context,
          title: 'Перед загрузкой документа, укажите данные - ${element.label}',
          confirmBtnText: 'Далее',
          buttonTitle: 'Далее',
          hint: element.label,
          isCode: false,
          onConfirm: (value, {dialogContext}) {
            fields.add({"id": element.id, "value": value});
            Navigator.pop(dialogContext!);
          },
        );
      }
      String savePath = await getFilePath('${item.title}.docx');
      DownloadedDocument? downloadedDocument =
          await context.read<MainCubit>().downloadDocument(
                item.id,
                clientId,
                fields,
              );

      if (downloadedDocument != null) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();

        if (statuses[Permission.storage]!.isGranted) {
          File file = File(savePath);
          var raf = file.openSync(mode: FileMode.write);
          raf.writeStringSync(
            docUrl + downloadedDocument.pathDocumentDownloaded,
          );

          await raf.close();
        }
        await OpenFile.open(savePath);
        return savePath;
      }
    }
  }

  getDocuments() async {
    await context.read<MainCubit>().getMyDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return DocumentsScaffold(
      body: BlocBuilder<MainCubit, MainState>(
        buildWhen: (previous, current) {
          if (current is MyDocumentGeted) {
            documents = current.documents;
          }
          return true;
        },
        builder: (context, snapshot) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: documents.length,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              GlobalKey globalKey = GlobalKey();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    createRoute(CurrentDocumentView(item: documents[index])),
                  );
                },
                child: Container(
                  height: 136.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  margin:
                      EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.only(left: 22.w),
                            child: Text(
                              documents[index].title,
                              style: GoogleFonts.poppins(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 22.w),
                                child: Text(
                                  'Дата создания: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('d MMMM, y год', 'ru')
                                    .format(documents[index].dateCreated),
                                style: GoogleFonts.poppins(
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  iconSelectModal(
                                    context,
                                    getWidgetPosition(globalKey),
                                    (widgetIndex) {
                                      deleteDialog(
                                        context: context,
                                        title:
                                            'Вы действительно\nхотите удалить\nдокумент?',
                                        onConfirm: () async {
                                          bool? result = await context
                                              .read<MainCubit>()
                                              .deleteDocument(
                                                documents[index].id,
                                              );
                                          if (result != null) {
                                            await context
                                                .read<MainCubit>()
                                                .getMyDocuments();
                                          }
                                          // Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 26.h,
                                  width: 26.w,
                                  key: globalKey,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.only(left: 22.w),
                                  child: SvgPicture.asset(
                                    'assets/icons/more.svg',
                                    height: 6.h,
                                    width: 26.h,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (documents[index].pdfFileLocation !=
                                      null) {
                                    // Share.share(docUrl +
                                    //     documents[index].pdfFileLocation!);
                                    downloadDocument(documents[index]);
                                  }
                                },
                                child: Container(
                                  height: 26.h,
                                  width: 111.w,
                                  margin: EdgeInsets.only(right: 12.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60.r),
                                    color: AppColors.buttonBlueColor,
                                  ),
                                  child: Text(
                                    'Поделиться',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.h,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(top: 17.h, right: 16.w),
                            child:
                                SvgPicture.asset('assets/icons/docs_brown.svg'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget clientList() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      height: 400.h,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Center(
            child: Text(
              'Выберите клиента для формирования документа.',
              style: GoogleFonts.poppins(
                color: AppColors.buttonBlueColor,
                fontSize: 24.h,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // SizedBox(height: 20.h),
          FutureBuilder<List<UserModel>?>(
              future: context.read<MainCubit>().getClients(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  clients = snapshot.data!;
                }
                return Stack(
                  children: [
                    SizedBox(
                      height: 230.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: 30.h),
                          itemCount: clients.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  snapshot.data![index].id,
                                );
                              },
                              child: currentCategory(
                                clients[index].name.toString(),
                                clients[index],
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 100.h),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget currentCategory(String title, UserModel userModel) {
    return Container(
      height: 55.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 22.w).add(
        EdgeInsets.only(top: 20.h),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.r,
            color: const Color.fromRGBO(0, 0, 0, 0.25),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 22.w),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
            ),
          ),
          const Expanded(child: SizedBox()),
          if (userModel.avatarPath != null)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(docUrl + userModel.avatarPath!),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.all(10.0),
              // child: Image.network(
              //   docUrl + userModel.avatarPath!,
              //   fit: BoxFit.cover,
              // ),
            )
          else
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/person.svg',
                height: 40,
                width: 40,
                color: AppColors.greyColor,
              ),
            ),
        ],
      ),
    );
  }
}
