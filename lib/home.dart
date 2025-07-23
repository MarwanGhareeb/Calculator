import 'package:calculator/button.dart';
import 'package:calculator/calculator.dart';
import 'package:calculator/common_code.dart';
import 'package:calculator/equation_provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _equation = TextEditingController();

  int countFloatingPoints = 0;

  final List<String> buttons = [
    '(',
    ')',
    '√',
    '^',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '/',
    '1',
    '2',
    '3',
    '-',
    '.',
    '0',
    '=',
    '+',
  ];

  double? output;

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(backgroundColor: black, toolbarHeight: 20,),
      body: EquationProvider(
        equation: _equation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _equation,
                cursorWidth: 2,
                cursorHeight: 40,
                readOnly: true,
                showCursor: true,
                cursorColor: Colors.black,
                focusNode: myFocusNode,
                style: TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            Container(
                alignment: Alignment.centerRight,
                color: black,
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "${output == null ? '' : output == output!.toInt() ? output!.toInt() : output}  ",
                    style: TextStyle(color: green, fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Button(
                      char: 'C',
                      onPress: () {
                        _equation.text = '';
                        output = null;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Button(
                    char: '',
                    icon: Icon(
                      Icons.backspace_sharp,
                      color: white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  double spacing = 10;

                  int rowCount = (buttons.length / crossAxisCount).ceil();
                  double buttonHeight =
                      (constraints.maxHeight - (rowCount - 1) * spacing) /
                      rowCount;
                  double buttonWidth =
                      (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                      crossAxisCount;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: buttons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: buttonWidth / buttonHeight,
                      ),
                      itemBuilder: (context, index) {
                        return Button(
                          char: buttons[index],
                          onPress: buttons[index] == '='
                              ? () => setState(
                                  () => output = Calculator(
                                    _equation.text,
                                    context,
                                  ).calculator(),
                                )
                              : null,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
