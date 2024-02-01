import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/dialogs.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';
import 'package:prosto_doc/core/helpers/images.dart';
import 'package:prosto_doc/core/models/document_model.dart';
import 'package:prosto_doc/core/models/downloaded_document.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:open_file/open_file.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class CurrentDocumentView extends StatefulWidget {
  final Item item;
  const CurrentDocumentView({super.key, required this.item});

  @override
  State<CurrentDocumentView> createState() => _CurrentDocumentViewState();
}

class _CurrentDocumentViewState extends State<CurrentDocumentView> {
  List<Map<String, dynamic>> fields = [];

  downloadDocument() async {
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
      for (var element in widget.item.fields) {
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
      String savePath = await getFilePath('${widget.item.title}.docx');
      DownloadedDocument? downloadedDocument =
          await context.read<MainCubit>().downloadDocument(
                widget.item.id,
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

  // Future<String?> getPDF(int id, int pin) async {
  //   try {
  //     String savePath = await getFilePath('$id$pin.docx');
  //     final response = await dio.get(
  //       '$server/export/invoice/pdf/?ID=$id$pin',
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       Map<Permission, PermissionStatus> statuses = await [
  //         Permission.storage,
  //       ].request();

  //       if (statuses[Permission.storage]!.isGranted) {
  //         File file = File(savePath);
  //         var raf = file.openSync(mode: FileMode.write);
  //         raf.writeFromSync(response.data);
  //         await raf.close();
  //       }
  //       return savePath;
  //     }
  //   } catch (e) {}

  //   return null;
  // }

  List<UserModel> clients = [];

  @override
  Widget build(BuildContext context) {
    print(docUrl + widget.item.pdfFileLocation!);
    GlobalKey globalKey = GlobalKey();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          SizedBox(height: 68.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 29.h, top: 8.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 20.h,
                    width: 20.w,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                    ),
                  ),
                ),
              ),
              Text(
                'Просмотр документа',
                style: GoogleFonts.poppins(
                  color: AppColors.buttonBlueColor,
                  fontSize: 24.h,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 29.h, top: 16.h),
                child: SizedBox(
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Stack(
              key: globalKey,
              children: [
                // Image.asset('assets/images/document.png'),
                SizedBox(
                  // height: 670.h,
                  height: double.infinity,
                  child: const PDF(
                    swipeHorizontal: true,
                  ).fromUrl(
                    docUrl + widget.item.pdfFileLocation!,
                    placeholder: (progress) => Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (error) =>
                        Center(child: Text(error.toString())),
                  ),
                ),
                Container(
                  height: 29.h,
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 17.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          deleteDialog(
                            context: context,
                            title:
                                'Вы действительно\nхотите удалить\nдокумент?',
                            onConfirm: () async {
                              bool? result = await context
                                  .read<MainCubit>()
                                  .deleteDocument(widget.item.id);
                              if (result != null) {
                                await context
                                    .read<MainCubit>()
                                    .getMyDocuments();
                                Navigator.pop(context);
                              }
                              // Navigator.pop(context);
                            },
                          );
                        },
                        child: Container(
                          height: 29.h,
                          // width: 29.w,
                          color: Colors.transparent,
                          child: SvgPicture.asset('assets/icons/trash.svg'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          downloadDocument();
                          // Share.share('Тут будет файл');
                        },
                        child: Container(
                          height: 29.h,
                          // width: 29.w,/
                          color: Colors.transparent,
                          child:
                              SvgPicture.asset('assets/icons/paperplane.svg'),
                        ),
                      ),
                      // SvgPicture.asset('assets/icons/paperplane.svg'),
                    ],
                  ),
                ),
                // SizedBox(height: 42.h),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     margin: EdgeInsets.only(bottom: 120.h),
                //     child: CustomButton(
                //         onTap: () {
                //           Navigator.pop(context);
                //         },
                //         title: 'Готово'),
                //   ),
                // ),
                // SizedBox(height: 121.h),
              ],
            ),
          )
        ],
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
              margin: EdgeInsets.all(10.0),
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
