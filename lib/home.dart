import 'package:calculator/button.dart';
import 'package:calculator/calculator.dart';
import 'package:calculator/common_colors.dart';
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
    myFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLACK,
      appBar: AppBar(backgroundColor: BLACK),
      body: EquationProvider(
        equation: _equation,
        child: Column(
          children: [
            inputEquation(),
            showOutput(),
            deleteButtons(),
            gridButtons(),
          ],
        ),
      ),
    );
  }

  Expanded inputEquation() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: TextField(
          controller: _equation,
          cursorWidth: 2,
          cursorHeight: 40,
          readOnly: true,
          showCursor: true,
          cursorColor: Colors.black,
          focusNode: myFocusNode,
          style: TextStyle(
            color: WHITE,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  Expanded showOutput() {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.centerRight,
        color: BLACK,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              key: ValueKey(output),
              "${output == null
                  ? ''
                  : output == output!.toInt()
                  ? output!.toInt()
                  : output}  ",
              style: TextStyle(
                color: GREEN,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row deleteButtons() {
    return Row(
      children: [
        Expanded(
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
          child: Button(
            char: '',
            icon: Icon(Icons.backspace_sharp, color: WHITE, size: 25),
          ),
        ),
      ],
    );
  }

  Expanded gridButtons() {
    return Expanded(
      flex: 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 4;
          double spacing = 10;

          int rowCount = (buttons.length / crossAxisCount).ceil();
          double buttonHeight =
              (constraints.maxHeight - (rowCount - 1) * spacing) / rowCount;
          double buttonWidth =
              (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
              crossAxisCount;

          return Padding(
            padding: const EdgeInsets.all(15),
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
                      ? () => setState(() {
                          try {
                            output = Calculator(
                              _equation.text,
                              context,
                            ).calculator();
                          } catch (e) {
                            snackBar(context, e.toString().substring(11));
                          }
                        })
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }

  snackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.red),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
