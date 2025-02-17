import 'package:flutter/material.dart';
import 'package:simple_month_year_picker/custom.dialog.dart';
import 'package:simple_month_year_picker/month.container.dart';
import 'package:simple_month_year_picker/month.model.dart';

class SimpleMonthYearPicker {
  /// list of Months
  static final List<MonthModel> _monthModelList = [
    MonthModel(index: 1, name: 'Ene'),
    MonthModel(index: 2, name: 'Feb'),
    MonthModel(index: 3, name: 'Mar'),
    MonthModel(index: 4, name: 'Abr'),
    MonthModel(index: 5, name: 'May'),
    MonthModel(index: 6, name: 'Jun'),
    MonthModel(index: 7, name: 'Jul'),
    MonthModel(index: 8, name: 'Ago'),
    MonthModel(index: 9, name: 'Sep'),
    MonthModel(index: 10, name: 'Oct'),
    MonthModel(index: 11, name: 'Nov'),
    MonthModel(index: 12, name: 'Dic'),
  ];

  /// shows dialog to select month and year
  ///
  /// The [context] argument must not be null.
  ///
  /// The [titleFontFamily] is optional.  Defaults to 'Rajdhani' fontFamily.
  /// It sets the font-family to use in 'Select Month' title.
  ///
  /// The [yearTextFontFamily] argument is optional. Defaults to 'Rajdhani' fontFamily.
  /// It sets the font-family to use in displayed year .
  ///
  /// The [monthTextFontFamily] argument is optional. Defaults to 'Rajdhani' fontFamily.
  /// It sets the font-family to use in month text.
  ///
  /// The [backgroundColor] argument is optional. Defaults to Theme.of(context).scaffoldBackgroundColor.
  /// It sets the background color used in the dialog.
  ///
  /// The [selectionColor] argument is optional. Defaults to Theme.of(context).primaryColor.
  /// It sets the background color of selected month, text-color of remaining months and button color.
  ///
  /// The [barrierDismissible] argument is optional and is used to indicate whether tapping on the barrier will dismiss the dialog.
  ///  Defaults to true.
  ///
  ///
  
  static Future<String> showMonthYearPickerDialog({
    required BuildContext context,
    TextStyle? titleTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? monthTextStyle,
    Color? backgroundColor,
    Color? selectionColor,
    bool? barrierDismissible,
    bool? disableFuture,
    int? selected 
  })  async {
    var primaryColor = const Color(0xff0066CC);
    var bgColor = const Color.fromARGB(255, 255, 255, 255);

    /// to get current year
    int selectedYear = DateTime.now().year;

    /// to get index corresponding to current month (1- Jan, 2- Feb,..)
    var selectedMonth = selected ?? DateTime.now().month;
    var width = MediaQuery.of(context).size.width;

    await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return CustomDialog(
            child: Stack(
              children: [
                Container(
                  height: 380,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Text(
                          'Seleccione un mes',
                          style: titleTextStyle ??
                              TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: SizedBox(
                          height: 240,
                          width: width * 0.85,
                          child: GridView.builder(
                            itemCount: _monthModelList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemBuilder: (_, index) {
                              var monthModel = _monthModelList[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedMonth = index + 1;
                                  });
                                },
                                onHover: (val) {},
                                child: MonthContainer(
                                  textStyle: index + 1 != selectedMonth ? monthTextStyle : TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                  month: monthModel.name,
                                  fillColor: index + 1 == selectedMonth
                                      ? primaryColor
                                      : bgColor,
                                  borderColor: index + 1 == selectedMonth
                                      ? primaryColor
                                      : bgColor,
                                  textColor: index + 1 != selectedMonth
                                      ? primaryColor
                                      : bgColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border.all(
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              String selectedMonthString = selectedMonth < 10
                                  ? "0$selectedMonth"
                                  : "$selectedMonth";
                              var selectedDate = DateTime.parse(
                                  '$selectedYear-$selectedMonthString-01');

                              Navigator.pop(context, '$selectedYear-$selectedMonthString');
                            },
                            child: Container(
                              height: 40,
                              width: 70,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: bgColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned.fill(
                  top: 10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedYear = selectedYear - 1;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          selectedYear.toString(),
                          style: yearTextStyle ??
                              TextStyle(
                                fontSize: 25,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (!(disableFuture == true &&
                            selectedYear == DateTime.now().year))
                        IconButton(
                          onPressed: () {
                            // DOC: Give user option to disable future years.
                            if (disableFuture == true &&
                                selectedYear == DateTime.now().year) {
                              null;
                            } else {
                              setState(() {
                                selectedYear = selectedYear + 1;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: primaryColor,
                          ),
                          )
                        else
                          SizedBox(
                            width: 50,
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
    String selectedMonthString =
        selectedMonth < 10 ? "0$selectedMonth" : "$selectedMonth";
    return '$selectedYear-$selectedMonthString';
  }
}
