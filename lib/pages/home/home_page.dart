import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/routes/names.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/home/bloc/home_page_blocs.dart';
import 'package:login/pages/home/bloc/home_page_states.dart';
import 'package:login/pages/home/widgets/home_page_widgets.dart';

//import '../../common/entities/entities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*let UserItem userProfile;
  @override
  void initState() {
    super.initState();
    //_homeController = _homeController(context: context);
   // _homeController.init();
   userProfile=HomeController(context:context).userProfile;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(/*userProfile.avatar.toString()*/),
        body: BlocBuilder<HomePageBlocs, HomePageStates>(
            builder: (context, state) {
          print("chek my status${state.courseItem}");
          return Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
            child: CustomScrollView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              slivers: [
                SliverToBoxAdapter(
                  child: HomePageText("Hello,",
                      color: AppColors.primaryThreeElementText),
                ),
                SliverToBoxAdapter(
                  child:
                      HomePageText("abd", color: AppColors.primaryText, top: 5),
                ),
                SliverPadding(padding: EdgeInsets.only(top: 20.h)),
                SliverToBoxAdapter(
                  child: searchView(),
                ),
                SliverToBoxAdapter(
                  child: slidersView(context, state),
                ),
                SliverToBoxAdapter(
                  child: menuView(),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.h, horizontal: 0.w),
                  sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(childCount: 4,
                          (BuildContext context, int index) {
                        return GestureDetector(
                          //من هنا نريد أن نتمكن من الانتقال إلى صفحة جديدة
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.COURSE_DETAIL, arguments: {
                              //"id": state.courseItem.elementAt(index).id, //الكورسات يلي بدي مررها هون لازم يكون في إلها معرّف
                            });
                          },
                          child: courseGrid(),
                        );
                      }),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1.6)),
                )
              ],
            ),
          );
        }));
  }
}
