import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rakwa/main.dart';

class AllPhotos extends StatefulWidget {
  const AllPhotos({Key? key, this.images}) : super(key: key);

  final List<String>? images;

  @override
  State<AllPhotos> createState() => _AllPhotosState();
}

class _AllPhotosState extends State<AllPhotos> {
  List<GalleryExampleItem> galleryItems = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.images!.length; i++) {
      galleryItems.add(GalleryExampleItem(
          id: i.toString(), resource: widget.images?[i] ?? ""));
    }
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.resources.color.background,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const HeaderPhotos(),
              Flexible(
                fit: FlexFit.loose,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: widget.images?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.75,
                      crossAxisCount: 2),
                  itemBuilder: (_, int index) {
                    return AllPhotosItem(
                      image: widget.images?[index],
                      onCLick: () {
                        open(context, index);
                      },
                    );
                  },
                ),
              ),
            ]),
      ),
    );
  }
}

class HeaderPhotos extends StatelessWidget {
  const HeaderPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: 16),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 0.5, color: MyApp.resources.color.borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                  child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.black,
              )),
            ),
          ),
        ),
        const Spacer(),
        const Text(
          "All photos",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: 42,
          width: 42,
        ),
        const SizedBox(width: 16),
      ]),
    );
  }
}

class AllPhotosItem extends StatelessWidget {
  const AllPhotosItem({Key? key, this.onCLick, this.image}) : super(key: key);
  final Function? onCLick;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 8),
      height: 290,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
          border:
              Border.all(width: 0.5, color: MyApp.resources.color.borderColor)),
      child: Stack(children: [
        Container(
          width: 220,
          height: 270,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image.network(
              image ?? "",
              width: 214,
              height: 276,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          width: 220,
          height: 290,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onCLick!();
              },
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
        )
      ]),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
   GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Positioned(
              top: 40,
              left: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryExampleItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}

class GalleryExampleItem {
  GalleryExampleItem({
    required this.id,
    required this.resource,
    this.isSvg = false,
  });

  final String id;
  final String resource;
  final bool isSvg;
}
