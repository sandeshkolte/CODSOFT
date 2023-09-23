import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget calcbutton(String btntext, Color? btncolor, Color textcolor) {
    return ElevatedButton(
      onPressed: () {
        calculation(btntext);
      },
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: btncolor,
          padding: const EdgeInsets.all(20)),
      child: Text(
        btntext,
        style: TextStyle(fontSize: 35, color: textcolor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Calculator',
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.end,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 100),
                    ),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              calcbutton('AC', Colors.grey, Colors.black),
              calcbutton('+/-', Colors.grey, Colors.black),
              calcbutton('%', Colors.grey, Colors.black),
              calcbutton('/', Colors.orange, Colors.white),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              calcbutton('7', Colors.grey[850], Colors.white),
              calcbutton('8', Colors.grey[850], Colors.white),
              calcbutton('9', Colors.grey[850], Colors.white),
              calcbutton('x', Colors.orange, Colors.white),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              calcbutton('4', Colors.grey[850], Colors.white),
              calcbutton('5', Colors.grey[850], Colors.white),
              calcbutton('6', Colors.grey[850], Colors.white),
              calcbutton('+', Colors.orange, Colors.white),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              calcbutton('1', Colors.grey[850], Colors.white),
              calcbutton('2', Colors.grey[850], Colors.white),
              calcbutton('3', Colors.grey[850], Colors.white),
              calcbutton('-', Colors.orange, Colors.white),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      calculation('0');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.fromLTRB(34, 20, 128, 20)),
                    child: const Text(
                      '0',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    )),
                calcbutton('.', Colors.grey[850], Colors.white),
                calcbutton('=', Colors.orange, Colors.white),
              ],
            )
          ],
        ),
      ),
    );
  }

  //Calculator logic
  dynamic text = '';
  double numOne = 0;
  double numTwo = 0;

  dynamic result = '';
  dynamic finalResult = '';
  dynamic opr = '';
  dynamic preOpr = '';
  void calculation(btnText) {
    if (btnText == 'AC') {
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = text;
      opr = '';
      preOpr = '';
    } else if (opr == '=' && btnText == '=') {
      if (preOpr == '+') {
        finalResult = add();
      } else if (preOpr == '-') {
        finalResult = sub();
      } else if (preOpr == 'x') {
        finalResult = mul();
      } else if (preOpr == '/') {
        finalResult = div();
      }
    } else if (btnText == '+' ||
        btnText == '-' ||
        btnText == 'x' ||
        btnText == '/' ||
        btnText == '=') {
      if (numOne == 0) {
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }

      if (opr == '+') {
        finalResult = add();
      } else if (opr == '-') {
        finalResult = sub();
      } else if (opr == 'x') {
        finalResult = mul();
      } else if (opr == '/') {
        finalResult = div();
      }
      preOpr = opr;
      opr = btnText;
      result = '';
    } else if (btnText == '%') {
      result = numOne / 100;
      finalResult = doesContainDecimal(result);
    } else if (btnText == '.') {
      if (!result.toString().contains('.')) {
        result = '$result.';
      }
      finalResult = result;
    } else if (btnText == '+/-') {
      result.toString().startsWith('-')
          ? result = result.toString().substring(1)
          : result = '-$result';
      finalResult = result;
    } else {
      result = result + btnText;
      finalResult = result;
    }

    setState(() {
      text = finalResult;
    });
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String doesContainDecimal(dynamic result) {
    if (result.toString().contains('.')) {
      List<String> splitDecimal = result.toString().split('.');
      if (!(int.parse(splitDecimal[1]) > 0)) {
        return result = splitDecimal[0].toString();
      }
    }
    return result;
  }
}
