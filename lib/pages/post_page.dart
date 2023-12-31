import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:inha_capstone_project_byoa/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Uint8List? mobileImage = Get.arguments;
  final key = GlobalKey();
  Uint8List? imageBytes;

  static const List<String> imageLinks = [
    "https://images.unsplash.com/photo-1550853024-fae8cd4be47f?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzV8fCVFQiU4RiU5OSVFQiVBQyVCQ3xlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1497119146420-012f8fc80a3a?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTJ8fCVFQiU4RiU5OSVFQiVBQyVCQ3xlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1497752531616-c3afd9760a11?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fCVFQiU4RiU5OSVFQiVBQyVCQ3xlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1679678691006-3afa56204979?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxzZWFyY2h8MXx8JUVCJUIwJUIwJUVBJUIyJUJEfGVufDB8fDB8fHww",
    "https://plus.unsplash.com/premium_photo-1676009619407-18a5121f9687?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8JUVCJUIwJUIwJUVBJUIyJUJEfGVufDB8fDB8fHww",
    "https://images.unsplash.com/photo-1476820865390-c52aeebb9891?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fCVFQiVCMCVCMCVFQSVCMiVCRHxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1436397543931-01c4a5162bdb?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fCVFQiVCMCVCMCVFQSVCMiVCRHxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1606916928892-3e15e20c5c0c?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzZ8fCVFRCU4MSVBQyVFQiVBNiVBQyVFQyU4QSVBNCVFQiVBNyU4OCVFQyU4QSVBNCUyMCVFQiVCMCVCMCVFQSVCMiVCRHxlbnwwfHwwfHx8MA%3D%3D",
  ];

  @override
  void initState() {
    super.initState();
    controller = PainterController(
      settings: PainterSettings(
        text: TextSettings(
          focusNode: textFocusNode,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, color: red, fontSize: 18),
        ),
        freeStyle: const FreeStyleSettings(
          color: red,
          strokeWidth: 5,
        ),
        shape: ShapeSettings(
          paint: shapePaint,
        ),
        scale: const ScaleSettings(
          enabled: true,
          minScale: 1,
          maxScale: 5,
        ),
      ),
    );
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);
  }

  Future<ui.Image> loadImage(Uint8List imageData) async {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }

  Future<Uint8List?> captureImage() async {
    double pixelRatio = 1;
    try {
      RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: pixelRatio);
      ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Widget buildDefault(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        // Listen to the controller and update the UI when it updates.
        child: ValueListenableBuilder<PainterControllerValue>(
            valueListenable: controller,
            child: const Text("Draw your app"),
            builder: (context, _, child) {
              return AppBar(
                title: child,
                centerTitle: true,
                backgroundColor: Colors.black,
                actions: [
                  // Delete the selected drawable
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.eraser(),
                    ),
                    onPressed: controller.selectedObjectDrawable == null ? null : removeSelectedDrawable,
                  ),
                  // Delete the selected drawable
                  IconButton(
                    icon: const Icon(
                      Icons.flip,
                    ),
                    onPressed: controller.selectedObjectDrawable != null && controller.selectedObjectDrawable is ImageDrawable ? flipSelectedImageDrawable : null,
                  ),
                  // Redo action
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.arrowClockwise(),
                    ),
                    onPressed: controller.canRedo ? redo : null,
                  ),
                  // Undo action
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.arrowCounterClockwise(),
                    ),
                    onPressed: controller.canUndo ? undo : null,
                  ),
                ],
              );
            }),
      ),
      // Generate image
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          imageBytes = await captureImage();
          // print(imageBytes);
          if (imageBytes != null) {
            // await uploadImage(imageBytes);
            Get.toNamed('/post2', arguments: imageBytes);
          } else {
            print('서버에 업로드 실패');
          }
        },
        child: Icon(
          PhosphorIcons.fileImage(),
        ),
      ),
      body: RepaintBoundary(
        key: key,
        child: Stack(
          children: [
            Center(child: Image.memory(mobileImage ?? Uint8List(0))),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FlutterPainter(controller: controller),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, _, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white54,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.freeStyleMode != FreeStyleMode.none) ...[
                              const Divider(),
                              const Text("Free Style Settings"),
                              // Control free style stroke width
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(min: 2, max: 25, value: controller.freeStyleStrokeWidth, onChanged: setFreeStyleStrokeWidth),
                                  ),
                                ],
                              ),
                              if (controller.freeStyleMode == FreeStyleMode.draw)
                                Row(
                                  children: [
                                    const Expanded(flex: 1, child: Text("Color")),
                                    // Control free style color hue
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(min: 0, max: 359.99, value: HSVColor.fromColor(controller.freeStyleColor).hue, activeColor: controller.freeStyleColor, onChanged: setFreeStyleColor),
                                    ),
                                  ],
                                ),
                            ],
                            if (textFocusNode.hasFocus) ...[
                              const Divider(),
                              const Text("Text settings"),
                              // Control text font size
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Font Size")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(min: 8, max: 96, value: controller.textStyle.fontSize ?? 14, onChanged: setTextFontSize),
                                  ),
                                ],
                              ),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(min: 0, max: 359.99, value: HSVColor.fromColor(controller.textStyle.color ?? red).hue, activeColor: controller.textStyle.color, onChanged: setTextColor),
                                  ),
                                ],
                              ),
                            ],
                            if (controller.shapeFactory != null) ...[
                              const Divider(),
                              const Text("Shape Settings"),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller.shapePaint?.strokeWidth ?? shapePaint.strokeWidth,
                                        onChanged: (value) => setShapeFactoryPaint((controller.shapePaint ?? shapePaint).copyWith(
                                              strokeWidth: value,
                                            ))),
                                  ),
                                ],
                              ),

                              // Control shape color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor((controller.shapePaint ?? shapePaint).color).hue,
                                        activeColor: (controller.shapePaint ?? shapePaint).color,
                                        onChanged: (hue) => setShapeFactoryPaint((controller.shapePaint ?? shapePaint).copyWith(
                                              color: HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                                            ))),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Fill shape")),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Switch(
                                          value: (controller.shapePaint ?? shapePaint).style == PaintingStyle.fill,
                                          onChanged: (value) => setShapeFactoryPaint((controller.shapePaint ?? shapePaint).copyWith(
                                                style: value ? PaintingStyle.fill : PaintingStyle.stroke,
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, _, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Free-style eraser
            IconButton(
              icon: Icon(
                PhosphorIcons.eraser(),
                color: controller.freeStyleMode == FreeStyleMode.erase ? Theme.of(context).colorScheme.secondary : null,
              ),
              onPressed: toggleFreeStyleErase,
            ),
            // Free-style drawing
            IconButton(
              icon: Icon(
                PhosphorIcons.scribbleLoop(),
                color: controller.freeStyleMode == FreeStyleMode.draw ? Theme.of(context).colorScheme.secondary : null,
              ),
              onPressed: toggleFreeStyleDraw,
            ),
            // Add text
            IconButton(
              icon: Icon(
                PhosphorIcons.textT(),
                color: textFocusNode.hasFocus ? Theme.of(context).colorScheme.secondary : null,
              ),
              onPressed: addText,
            ),
            // Add sticker image
            IconButton(
              icon: Icon(
                PhosphorIcons.sticker(),
              ),
              onPressed: addSticker,
            ),
            // Add shapes
            if (controller.shapeFactory == null)
              PopupMenuButton<ShapeFactory?>(
                tooltip: "Add shape",
                itemBuilder: (context) => <ShapeFactory, String>{
                  LineFactory(): "Line",
                  ArrowFactory(): "Arrow",
                  DoubleArrowFactory(): "Double Arrow",
                  RectangleFactory(): "Rectangle",
                  OvalFactory(): "Oval",
                }
                    .entries
                    .map((e) => PopupMenuItem(
                        value: e.key,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              getShapeIcon(e.key),
                              color: Colors.black,
                            ),
                            Text(" ${e.value}")
                          ],
                        )))
                    .toList(),
                onSelected: selectShape,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    getShapeIcon(controller.shapeFactory),
                    color: controller.shapeFactory != null ? Theme.of(context).colorScheme.secondary : null,
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(
                  getShapeIcon(controller.shapeFactory),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => selectShape(null),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.lineSegment();
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrowUpRight();
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrowsHorizontal();
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle();
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle();
    return PhosphorIcons.polygon();
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw ? FreeStyleMode.draw : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase ? FreeStyleMode.erase : FreeStyleMode.none;
  }

  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  void addSticker() async {
    final imageLink = await showDialog<String>(
        context: context,
        builder: (context) => const SelectStickerImageDialog(
              imagesLinks: imageLinks,
            ));
    if (imageLink == null) return;
    controller.addImage(await NetworkImage(imageLink).image, const Size(100, 100));
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(textStyle: controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  void setTextColor(double hue) {
    controller.textStyle = controller.textStyle.copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void selectShape(ShapeFactory? factory) {
    controller.shapeFactory = factory;
  }

  void renderAndDisplayImage() {
    if (backgroundImage == null) return;
    final backgroundImageSize = Size(backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());

    // Render the image
    // Returns a [ui.Image] object, convert to to byte data and then to Uint8List
    final imageFuture = controller.renderImage(backgroundImageSize).then<Uint8List?>((ui.Image image) => image.pngBytes);

    // From here, you can write the PNG image data a file or do whatever you want with it
    // For example:
    // ```dart
    // final file = File('${(await getTemporaryDirectory()).path}/img.png');
    // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // ```
    // I am going to display it using Image.memory

    // Show a dialog with the image
    showDialog(context: context, builder: (context) => RenderedImageDialog(imageFuture: imageFuture));
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }
}

class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}

class SelectStickerImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectStickerImageDialog({Key? key, this.imagesLinks = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select sticker"),
      content: imagesLinks.isEmpty
          ? const Text("No images")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imagesLinks)
                      InkWell(
                        onTap: () => Navigator.pop(context, imageLink),
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: Image.network(imageLink, width: 300, height: 300, fit: BoxFit.cover),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
