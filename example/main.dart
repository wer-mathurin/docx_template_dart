import 'dart:io';

import 'package:docx_template/src/template.dart';
import 'package:docx_template/src/model.dart';

///
/// Read file template.docx, produce it and save
///
void main() async {
  final f = File("template.docx");
  final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

  /* 
    Or in the case of Flutter, you can use rootBundle.load, then get bytes
    
    final data = await rootBundle.load('lib/assets/users.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);
  */

  // Load test image for inserting in docx
  final testFileContent = await File('test.jpg').readAsBytes();

  Content c = Content();
  c
    ..add(TextContent("docname", "Simple docname"))
    ..add(TextContent("passport", "Passport NE0323 4456673"))
    ..add(TableContent("table", [
      RowContent()
        ..add(TextContent("key1", "Paul"))
        ..add(TextContent("key2", "Viberg"))
        ..add(TextContent("key3", "Engineer")),
      RowContent()
        ..add(TextContent("key1", "Alex"))
        ..add(TextContent("key2", "Houser"))
        ..add(TextContent("key3", "CEO & Founder"))
        ..add(ListContent("tablelist", [
          TextContent("value", "Mercedes-Benz C-Class S205"),
          TextContent("value", "Lexus LX 570")
        ]))
    ]))
    ..add(ListContent("list", [
      TextContent("value", "Engine")
        ..add(ListContent("listnested", [
          PlainContent("value")
            ..add(TextContent("normal", "BMW MTech"))
            ..add(TextContent("bold", "S55")),
          PlainContent("value")
            ..add(TextContent("normal", "BMW"))
            ..add(TextContent("bold", "N55")),
        ])),
      TextContent("value", "Gearbox"),
      TextContent("value", "Chassis")
    ]))
    ..add(ListContent("plainlist", [
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Paul"))
            ..add(TextContent("key2", "Viberg"))
            ..add(TextContent("key3", "Engineer"))
            ..add(ImageContent('img', testFileContent)),
          RowContent()
            ..add(TextContent("key1", "Alex"))
            ..add(TextContent("key2", "Houser"))
            ..add(TextContent("key3", "CEO & Founder"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Mercedes-Benz C-Class S205"),
              TextContent("value", "Lexus LX 570")
            ]))
            ..add(ImageContent('img', testFileContent))
        ])),
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Nathan"))
            ..add(TextContent("key2", "Anceaux"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent(
                "tablelist", [TextContent("value", "Peugeot 508")])),
          RowContent()
            ..add(TextContent("key1", "Louis"))
            ..add(TextContent("key2", "Houplain"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Range Rover Velar"),
              TextContent("value", "Lada Vesta SW Sport")
            ]))
        ])),
    ]))
    ..add(ListContent("multilineList", [
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 1')),
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 2')),
      PlainContent("multilinePlain")
        ..add(TextContent('multilineText', 'line 3'))
    ]))
    ..add(TextContent('multilineText2', 'line 1\nline 2\n line 3'))
    ..add(ImageContent('img', testFileContent));
  ;

  final d = await docx.generate(c);
  final of = File('generated.docx');
  await of.writeAsBytes(d);
}
