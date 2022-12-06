// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as api;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CEP 1.0'),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _txtCep = TextEditingController();

  double _distCampos = 40;
  var _msgErro = '';
  var _dsLogradouro = '';
  var _dsBairro = '';
  var _dsCidade = '';
  var _dsUf = '';

  var _estilo1 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 8, 52, 114));
  var _estilo2 = TextStyle(fontSize: 18, decoration: TextDecoration.underline);

  void _retornaDadosCep(int cep) async {
    String url = 'https://viacep.com.br/ws/${cep.toString()}/json/';

    api.Response response;
    response = await api.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);

    setState(() {
      _dsLogradouro = retorno['logradouro'];
      _dsBairro = retorno['bairro'];
      _dsCidade = retorno['localidade'];
      _dsUf = retorno['uf'];
      if (_dsLogradouro == null) {
        _msgErro = 'Erro, CEP não encontrado';
        _dsLogradouro = ' ';
        _dsBairro = ' ';
        _dsCidade = ' ';
        _dsUf = ' ';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _msgErro,
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    maxLength: 8,
                    controller: _txtCep,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Informe o CEP'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _msgErro = '';
                          if (_txtCep.text.length != 8) {
                            _msgErro = 'CEP deve conter 8 dígitos';
                          } else {
                            _retornaDadosCep(int.parse(_txtCep.text));
                          }
                        });
                      },
                      child: Text('Enviar')),
                )
              ],
            ),
            //============   Informações do CEP =============
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      'Logradouro ',
                      style: _estilo1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: _distCampos),
                    child: Text(
                      _dsLogradouro,
                      style: _estilo2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      'Bairro ',
                      style: _estilo1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: _distCampos),
                    child: Text(
                      _dsBairro,
                      style: _estilo2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      'Cidade ',
                      style: _estilo1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: _distCampos),
                    child: Text(
                      _dsCidade,
                      style: _estilo2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      'UF ',
                      style: _estilo1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: _distCampos),
                    child: Text(
                      _dsUf,
                      style: _estilo2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
