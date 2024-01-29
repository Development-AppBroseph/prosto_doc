import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/dialogs.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';
import 'package:prosto_doc/core/models/client_model.dart';
import 'package:prosto_doc/core/models/document_model.dart';
import 'package:prosto_doc/core/models/downloaded_document.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/client_profile_view.dart';
import 'package:prosto_doc/features/home/views/navigation/current_document_view.dart';
import 'package:share_plus/share_plus.dart';

class ClientInfoView extends StatefulWidget {
  UserModel? clientModel;
  ClientInfoView({super.key, required this.clientModel});

  @override
  State<ClientInfoView> createState() => _ClientInfoViewState();
}

class _ClientInfoViewState extends State<ClientInfoView> {
  XFile? currentImage;

  FocusNode nameFocus = FocusNode();

  FocusNode lastNameFocus = FocusNode();

  FocusNode surnameFocus = FocusNode();

  FocusNode phoneFocus = FocusNode();

  FocusNode dateFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late DateTime _currentdate;

  List<Item> documents = [];

  @override
  void initState() {
    if (widget.clientModel != null) {
      setState(() {
        nameController.text = widget.clientModel?.name ?? '';
        lastnameController.text = widget.clientModel?.surname ?? '';
        surnameController.text = widget.clientModel?.patronymic ?? '';
        // phoneController.text = widget.clientModel!;
        // nameController.text = widget.clientModel!.name;
        // _currentdate = widget.clientModel!.dateBirth;
        // dateController.text =
        //     DateFormat('dd.MM.yyyy').format(widget.clientModel!.dateBirth);
      });
    }
    getDocuments();
    super.initState();
  }

  downloadDocument(int documentId, String title) async {
    String savePath = await getFilePath('$title.docx');
    DownloadedDocument? downloadedDocument =
        await context.read<MainCubit>().downloadDocument(
      documentId,
      widget.clientModel!.id,
      [],
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

  getDocuments() async {
    DocumentModel? documentModel = await context
        .read<MainCubit>()
        .getClientDocuments(widget.clientModel!.id);

    if (documentModel != null) {
      setState(() {
        documents = documentModel.items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 77.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 29.h, top: 16.h),
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
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    '${nameController.text} ${lastnameController.text}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24.h,
                      fontWeight: FontWeight.w700,
                      color: AppColors.buttonBlueColor,
                    ),
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
            SizedBox(height: 33.h),
            Text(
              'Раннее сформированные\nдокументы',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20.h,
                fontWeight: FontWeight.w700,
                color: AppColors.buttonBlueColor,
              ),
            ),
            SizedBox(height: 20.h),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return docWidget(index);
              },
            ),
            SizedBox(height: 75.h),
            CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  createRoute(
                    ClientProfileView(
                      clientModel: widget.clientModel,
                    ),
                  ),
                );
              },
              title: 'Редактировать данные',
            ),
            SizedBox(height: 140.h),
          ],
        ),
      ),
    );
  }

  Widget docWidget(int index) {
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
        margin: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
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
                      documents[index].dateCreated.toString(),
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
                        if (documents[index].pdfFileLocation != null) {
                          // Share.share(docUrl +
                          //     documents[index].pdfFileLocation!);
                          downloadDocument(
                              documents[index].id, documents[index].title);
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
                  child: SvgPicture.asset('assets/icons/docs_brown.svg'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
