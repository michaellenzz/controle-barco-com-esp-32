import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Controle());
  }
}

class Controle extends StatefulWidget {
  const Controle({super.key});

  @override
  State<Controle> createState() => _ControleState();
}

class _ControleState extends State<Controle> {
  bool andando = false;
  String direcao = 'Reto';
  String enderecoIP = '192.168.4.1';

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(direcao);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(4),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
                onHighlightChanged: (value) {
                  setState(() {
                    if (value) {
                      enviarComandosEsp32('27/on');
                      direcao = 'Esquerda';
                    } else {
                      enviarComandosEsp32('27/off');
                      direcao = 'Reto';
                    }
                    //value ? direcao = 'Direita' : direcao = 'Reto';
                  });
                },
                child: SizedBox(
                    width: width * 0.35,
                    height: width * 0.35,
                    child: Icon(
                      Icons.arrow_circle_left_rounded,
                      color: direcao == 'Esquerda'
                          ? Colors.pink[900]
                          : Colors.pink,
                      size: width * 0.35,
                    )),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: width * 0.1,
                    height: width * 0.1,
                    child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            andando ? andando = false : andando = true;
                          });
                        },
                        icon: Icon(
                          andando
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          color: andando ? Colors.red : Colors.pink,
                          size: width * 0.10,
                        )),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    andando
                        ? '      Desligar os motores'
                        : '      Ligar os motores',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: andando ? Colors.red : Colors.pink),
                  )
                ],
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
                onHighlightChanged: (value) {
                  setState(() {
                    if (value) {
                      enviarComandosEsp32('26/on');
                      direcao = 'Direita';
                    } else {
                      enviarComandosEsp32('26/off');
                      direcao = 'Reto';
                    }
                    //value ? direcao = 'Direita' : direcao = 'Reto';
                  });
                },
                child: SizedBox(
                    width: width * 0.35,
                    height: width * 0.35,
                    child: Icon(
                      Icons.arrow_circle_right_rounded,
                      color:
                          direcao == 'Direita' ? Colors.pink[900] : Colors.pink,
                      size: width * 0.35,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future enviarComandosEsp32(comando) async {
    try {
      var url = Uri.http(enderecoIP, comando);
      await http.post(url);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
