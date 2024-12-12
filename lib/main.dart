
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/detailScreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import './widgets/reusable_text.dart';
import './widgets/simple_month_year_picker_CUSTOM.dart';
import './widgets/fake_data.dart';
import './widgets/resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:countup/countup.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainScreen())
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({
      Key? key
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  static List<String> mode = <String>['Móvil + Wifi', 'Móvil', 'Wifi'];
  final Duration animDuration = const Duration(milliseconds: 400);
  int touchedIndex = -1;

  //INIT DATA
  int mesSelected = -1;
  int anioSelected = 0;
  String mesAnioSelected = "Mes Año";
  int daysMonth = 0;
  double iconData1 = 0;
  String iconData1Length = "KB";
  double iconData2 = 0;
  String iconData2Length = "MINS";
  double iconData3 = 0;
  String iconData3Length = "KB";
  double iconData4 = 0;
  String iconData4Length = "KB";
  double centerData = 0;
  String centerDataLength = "KB";
  double percentData = 0.0;
  String dropdownMode = mode.first;
  List data = [];
  List dataApps = [];
  late List<BarChartGroupData> dataChart = List.generate(31, (i) {
    return generateGroup(i, 5, 0);
  });
  //END INIT DATA

  final _style1 =  const TextStyle(
    color: Colors.white, //widget.touchedBarColor,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  final _style2 =  const TextStyle(
    color: Colors.white, //widget.touchedBarColor,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  @override
  void initState() {
    var now = DateTime.now();
    var dateForDay = DateTime(now.year, now.month + 1, 0);

    setState(() {
        anioSelected = now.year;
        mesAnioSelected = "${meses[now.month - 1]}  ${now.year}";
        mesSelected = now.month;
        daysMonth = dateForDay.day;
    }); 

    //HERE TRY SIMULATE LOAD DATA
    Timer(const Duration(seconds: 3), () => loadData()
    );
    
    super.initState();

  }

  loadData() async{
    List newData = [];
    List newDataOthersMonths = [];
    List<BarChartGroupData> newDataChart = [];
    List<BarChartGroupData> othersMonths = [];
    List newDataApps = [];

    fakeDataDiciembre.entries.map((es) => {
        newData.add(es.value),
        newDataChart.add(
          generateGroup(es.key, 3, double.parse(es.value[0]))
        )
    }).toList();

    List.generate(daysMonth, (i) {
      var _random = Random().nextInt(80).toDouble();
      newDataOthersMonths.add([
        _random.toString(),
        "${Random().nextInt(80)} MB", 
        "${Random().nextInt(80)} MB", 
        "${Random().nextInt(80)} MB", 
        "${Random().nextInt(80)} Mins"
      ]);
      othersMonths.add(
        generateGroup(i, 3, _random)
      );
    });

    fakeDataApss.entries.map((es) => {
        newDataApps.add([
          es.value[0],
          es.value[1],
          "${Random().nextInt(100)}",
          "${Random().nextInt(999)}",
          "MINS",
          "${Random().nextInt(999)}",
          "GB"
        ]),
    }).toList();
    
    newDataApps.sort((b, a) => a[2].compareTo(b[2]));

    setState(() {
      data = mesSelected == 12 ? newData : newDataOthersMonths;
      dataChart = mesSelected == 12 ? newDataChart : othersMonths;
      dataApps = newDataApps;

      iconData1 = Random().nextInt(999).toDouble();
      iconData1Length = "MB";
      iconData2 = Random().nextInt(999).toDouble();
      iconData2Length = "MINS";
      iconData3 = Random().nextInt(999).toDouble();
      iconData3Length = "MB";
      iconData4 = Random().nextInt(999).toDouble();
      iconData4Length = "TB";
      percentData = Random().nextInt(100).toDouble() * 0.01;
      centerData = Random().nextInt(999).toDouble();
      centerDataLength = "MB";
    });
  }


  setDate() async{
    final selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
      context: context,
      titleTextStyle: const TextStyle(
        fontSize: 20
      ),
      monthTextStyle: const TextStyle(),
      yearTextStyle: const TextStyle(),
      disableFuture: true,
      selected: mesSelected
    );

    try {
        int index = selectedDate.indexOf("-");
        var anio = int.parse(selectedDate.substring(0,index).trim());
        var mes = int.parse(selectedDate.substring(index+1).trim());
        var dateForDay = DateTime(anio, mes + 1, 0);

        setState(() {
            anioSelected = anio;
            mesAnioSelected = "${meses[mes - 1]}  ${selectedDate.substring(0,index).trim()}";
            mesSelected = mes;
            daysMonth = dateForDay.day;
        });
        
        loadData();
    } catch (e) {}
  }

  
  @override
  Widget build(BuildContext context) {
    
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReusableText(
                    title: "Uso mensual de datos por app",
                    size: 18,
                    weight: FontWeight.w500,
                    color: Color(0xff000000),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(  
                    children: [
                      Expanded(
                        child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 1,
                              ),
                              InkWell(
                                onTap: () {
                                    setDate();
                                },
                                child: Row(
                                  children: [
                                    ReusableText(
                                      title: mesAnioSelected,
                                      size: 16,
                                      weight: FontWeight.w400,
                                      color: Color(0xffA0A0A0),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(Icons.expand_more)
                                  ],
                                )
                              )
                            ],
                          )
                        
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DropdownMenu<String>(
                            trailingIcon: const Icon(Icons.expand_more),
                            selectedTrailingIcon: const Icon(Icons.expand_less),
                            width: 145,
                            textStyle: const TextStyle(
                              color: Color(0xffA0A0A0),
                              fontWeight: FontWeight.w400
                            ),
                            initialSelection: dropdownMode,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownMode = value!;
                              });
                              loadData();
                            },
                            inputDecorationTheme: const InputDecorationTheme(
                              contentPadding: EdgeInsets.all(0),
                              enabledBorder: OutlineInputBorder(
                                borderSide : BorderSide(color: Color.fromARGB(255, 255, 255, 255))
                              )
                            ),
                            dropdownMenuEntries: mode.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(value: value, label: value);
                            }).toList(),
                          )
                        ]
                      ) 
                      
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity! > 0) {
                        // User swiped Left
                        var newAnio = mesSelected == 1 ? anioSelected - 1 : anioSelected;
                        var newMes = mesSelected == 1 ? 12 : mesSelected - 1;

                        setState(() { 
                          anioSelected = newAnio;
                          mesSelected = newMes; 
                          mesAnioSelected =  meses[newMes - 1] + " " + newAnio.toString();
                        });

                        loadData();

                        
                      } else if (details.primaryVelocity! < 0) {

                        var newAnio = mesSelected == 12 ? anioSelected + 1 : anioSelected;
                        var newMes = mesSelected == 12 ? 1 : mesSelected + 1;

                        setState(() { 
                          anioSelected = newAnio;
                          mesSelected = newMes; 
                          mesAnioSelected =  meses[newMes - 1] + " " + newAnio.toString();
                        });

                        loadData();
                      }
                    },
                    child: Row(
                    children: [
                      Expanded(
                        child:  Container(
                                    height: height * 0.25,
                                    //padding: const EdgeInsets.only(right: 15, left: 0),
                                    child: BarChart(
                                      mainBarData(),
                                      duration: animDuration,
                                    ),
                                  )
                                
                        
                      )
                    ],
                  )),
                  Center(
                    child: CustomPaint( //                       <-- CustomPaint widget
                      size: Size(width, 20),
                      painter: MyPainter(),
                    ),
                  ),
                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Tooltip(
                            decoration: BoxDecoration(
                              color: Color(0xff313131),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 4),
                            richMessage: WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TIEMPO EN PANTALLA",
                                    style: _style1,
                                  ),
                                  Text(
                                    "Aqui se muestra el tiempo total que el \nusuario estuvo interactuando con todas \nlas APPS en primer plano",
                                    style: _style2,
                                  )
                                ],
                              ))
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width / 3,
                                  child: Column(

                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Color(0xffA0A0A0),
                                            size: 28.0,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Countup(
                                                begin: 0,
                                                end: iconData2,
                                                precision: 1,
                                                duration: const Duration(seconds: 2),
                                                separator: '.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xffA0A0A0)
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 1,
                                              ),
                                              ReusableText(
                                                title: iconData2Length,
                                                size: 10,
                                                weight: FontWeight.w400,
                                                color: Color(0xffA0A0A0),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Countup(
                                            begin: 0,
                                            end: iconData1,
                                            precision: 1,
                                            duration: const Duration(seconds: 2),
                                            separator: '.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xffA0A0A0)
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 1,
                                          ),
                                          ReusableText(
                                            title: iconData1Length,
                                            size: 10,
                                            weight: FontWeight.w400,
                                            color: Color(0xffA0A0A0),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )                              
                              ],  
                            )
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          
                          CustomPaint( //                       <-- CustomPaint widget
                            size: Size((width / 2) - 70, 20),
                            painter: MyPainter2(),
                          )

                        ],
                      ),

                      SizedBox(
                        width: width / 4.5,
                        child: Tooltip(
                            decoration: BoxDecoration(
                              color: Color(0xff313131),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 4),
                            richMessage: WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CONSUMO DE DATOS MENSUAL",
                                    style: _style1,
                                  ),
                                  Text(
                                    "Total de datos consumidos en el mes.",
                                    style: _style2,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "AZUL",
                                              style: _style1,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Datos de primer plano",
                                              style: _style2,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "VERDE",
                                              style: _style1,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Datos de segundo plano",
                                              style: _style2,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                    
                                    
                                  ),
                                  
                                ],
                              ))
                            ),
                            child: CircularPercentIndicator(
                          reverse: true,
                          radius:( width / 4.5) / 2,
                          lineWidth: 6.5,
                          percent: percentData,
                          center:  Column(  
                            children: [
                                SizedBox(
                                  height: 22,
                                ),
                                Countup(
                                  begin: 0,
                                  end: centerData,
                                  precision: 1,
                                  duration: const Duration(seconds: 1),
                                  separator: '.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xff000000)
                                  ),
                                ),
                                ReusableText(
                                  title: centerDataLength,
                                  size: 14,
                                  weight: FontWeight.w300,
                                  color: Color(0xffA0A0A0),
                                )
                            ]
                          ),
                          progressColor: const Color(0xff0066CC),
                          backgroundColor: const Color(0xff6CA117),
                          animation: true,
                          animationDuration: 1200,
                        )),
                      ),


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          
                          Row(  
                            children: [
                              SizedBox(
                                width: width / 6,
                                child: Tooltip(
                                  decoration: BoxDecoration(
                                    color: Color(0xff313131),
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  triggerMode: TooltipTriggerMode.tap,
                                  showDuration: const Duration(seconds: 4),
                                  richMessage: WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "CONSUMO DE DATOS MENSUAL",
                                          style: _style1,
                                        ),
                                        Text(
                                          "DATOS MOVILES",
                                          style: _style1,
                                        ),
                                        Text(
                                          "Total de datos consumido en el mes\nutilizando datos moviles",
                                          style: _style2,
                                        )
                                      ],
                                    ))
                                  ),
                                  child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 2.5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/vector3.png", width: 26,),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Countup(
                                          begin: 0,
                                          end: iconData3,
                                          precision: 1,
                                          duration: const Duration(seconds: 1),
                                          separator: '.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xffA0A0A0)
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        ReusableText(
                                          title: iconData3Length,
                                          size: 10,
                                          weight: FontWeight.w400,
                                          color: Color(0xffA0A0A0),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              ),
                              

                              SizedBox(
                                width: width / 6,
                                child: Tooltip(
                                decoration: BoxDecoration(
                                  color: Color(0xff313131),
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: const Duration(seconds: 4),
                                richMessage: WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CONSUMO DE DATOS MENSUAL EN",
                                        style: _style1,
                                      ),
                                      Text(
                                        "WIFI",
                                        style: _style1,
                                      ),
                                      Text(
                                        "Total de datos consumido en el mes\nutilizando WIFI",
                                        style: _style2,
                                      )
                                    ],
                                  ))
                                ),
                                child: Column(

                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.wifi,
                                          color: Color(0xffA0A0A0),
                                          size: 28.0,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Countup(
                                          begin: 0,
                                          end: iconData4,
                                          precision: 1,
                                          duration: const Duration(seconds: 1),
                                          separator: '.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xffA0A0A0)
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        ReusableText(
                                          title: iconData4Length,
                                          size: 10,
                                          weight: FontWeight.w400,
                                          color: Color(0xffA0A0A0),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              )
                            ],  
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          
                          CustomPaint( //                       <-- CustomPaint widget
                            size: Size((width / 2) - 70, 20),
                            painter: MyPainter2(),
                          ),
                          

                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.builder(
                    itemCount: dataApps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return DetailScreen(name: dataApps[index][1]);
                            }),
                          );
                        },
                        child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/"+dataApps[index][0], width: 35,),
                              const SizedBox(
                                width: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ReusableText(
                                        title: dataApps[index][1],
                                        size: 16,
                                        weight: FontWeight.w800,
                                        color: Color(0xff000000),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                     const Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Color(0xffA0A0A0),
                                        size: 24.0,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Countup(
                                            begin: 0,
                                            end: double.parse(dataApps[index][3]),
                                            precision: 1,
                                            duration: const Duration(seconds: 2),
                                            separator: '.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xffA0A0A0)
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 1,
                                          ),
                                          ReusableText(
                                            title: dataApps[index][4],
                                            size: 10,
                                            weight: FontWeight.w400,
                                            color: Color(0xffA0A0A0),
                                          )
                                        ],
                                      )
                                    ],
                                  ),

                                  SizedBox(
                                    height: 2,
                                  ),
                                  
                                  SizedBox(
                                    height: 6,
                                    width: (width * 0.60) * (double.parse(dataApps[index][2]) * 0.01),
                                    child: LinearPercentIndicator(
                                      restartAnimation: true,
                                      animateFromLastPercent: true,
                                      width: (width * 0.60) * (double.parse(dataApps[index][2]) * 0.01),
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 1500,
                                      percent: double.parse(dataApps[index][2]) * 0.01,
                                      barRadius: Radius.circular(55),
                                      progressColor: Color(0xff0066CC),
                                      backgroundColor: Color(0xff6CA117)
                                    ),
                                  ),

                                  SizedBox(
                                    height: 6,
                                  ),
                                  
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Countup(
                                          begin: 0,
                                          end: double.parse(dataApps[index][5]),
                                          precision: 1,
                                          duration: const Duration(seconds: 2),
                                          separator: '.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xffA0A0A0)
                                          ),
                                        ),
                                        ReusableText(
                                          title: dataApps[index][6],
                                          size: 12,
                                          weight: FontWeight.w400,
                                          color: Color(0xffA0A0A0),
                                        )
                                      ],
                                    )
                                  ],
                                ) 
                              )
                              
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          dataApps.length != (index + 1) ?
                            CustomPaint( //                       <-- CustomPaint widget
                              size: Size(width, 20),
                              painter: MyPainter2(),
                            ) : const SizedBox(
                              height: 0,
                            )
                        ],
                        )
                      );
                    }
                  ),
                  )
                ],
              ),
          ),
        ),
      );
  }


  Widget getTitles(double value, TitleMeta meta) {
    int val = value.toInt() + 1;
    if(
      val == 1 ||
      val == 8 ||
      val == 16 ||
      val == 24 ||
      val == (daysMonth) 
    ){
      
      var underText = "";

      switch (val) {
        case 1:
          underText = mesesLetras[mesSelected - 1];
          break;
        default:
          underText = val.toString();
          break;
      }

      const style = TextStyle(
        color: Color(0xffA0A0A0),
        fontWeight: FontWeight.normal,
        fontSize: 18
      );

      const style2 = TextStyle(
        color: Color(0xffA0A0A0),
        fontWeight: FontWeight.normal,
        fontSize: 10
      );

      Widget text = Column(
        children: [
          const RotatedBox(
            quarterTurns: 1,
            child: Text('-', style: style)
          ),
          Text(underText, style: style2)
        ],
      );
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: text,
      );

    }else{

      const style = TextStyle(
        color: Color(0xffA0A0A0),
        fontWeight: FontWeight.w800,
        fontSize: 14,
        height: 0.5
      );

      Widget text = const Text('.', style: style);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: text,
      );
    }

    
  }

  //MAIN CHART
  BarChartData mainBarData() {  
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => const Color(0xff313131),
          fitInsideHorizontally: true,
          tooltipMargin: -10,
          maxContentWidth: 220,
          tooltipRoundedRadius: 10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {

            var dataToltip = data[groupIndex];
            if(dataToltip[0] == "0"){
              return null;
            }

            var datos_utiizados = dataToltip[1] ?? "0";
            var primer_plano = dataToltip[2] ?? "0";
            var segundo_plano = dataToltip[3] ?? "0";
            var tiempo = dataToltip[4] ?? "0";

            var _day = groupIndex + 1;

            return BarTooltipItem(
              '',
              const TextStyle(),
              textAlign: TextAlign.start,
              children: <TextSpan>[
                TextSpan(
                  text: _day.toString() + " " + mesAnioSelected + " \n",
                  style: _style1,
                ),
                TextSpan(
                  text: "DATOS UTILIZADOS: " +datos_utiizados+ "\n",
                  style: _style1,
                ),
                TextSpan(
                  text: "  • 40MB Primer plano " + primer_plano + "\n",
                  style: _style2,
                ),
                TextSpan(
                  text: "  • 40MB Primer plano "+segundo_plano+"\n",
                  style: _style2,
                ),
                TextSpan(
                  text: "TIEMPO EN PANTALLA: "+tiempo,
                  style: _style1,
                )
              ],
            );
          },
        )
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: dataChart,
      gridData: const FlGridData(show: false),
    );
  }

  BarChartGroupData generateGroup(
    int x,
    double value1,
    double value2,
  ) {
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: value2,
          width: 6,
          borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              const Color(0xff6CA117),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1,
              value1 + value2,
              const Color(0xff0066CC),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        )
      ],
    );
  }

}







