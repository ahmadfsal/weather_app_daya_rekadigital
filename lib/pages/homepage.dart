import 'package:flutter/material.dart';
import 'package:weather_app_daya_rekadigital/model/cuaca_model.dart';
import 'package:weather_app_daya_rekadigital/helper.dart';
import 'package:weather_app_daya_rekadigital/model/wilayah_model.dart';
import 'package:weather_app_daya_rekadigital/repository/weather_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _cuacaTabController;
  String _idWilayah = '501192';

  @override
  void initState() {
    _cuacaTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          WeatherRepository.getListWilayah(),
          WeatherRepository.getListCuacaByIdWilayah(_idWilayah),
        ]),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                List data = snapshot.data as List;
                List<WilayahModel>? _listWilayah = data[0];
                List<CuacaModel>? _listCuaca = data[1];

                return _content(context, _listWilayah, _listCuaca);
              }

              if (snapshot.hasError) {
                return const Center(
                    child: Text('Terjadi kesalahan saat memuat data'));
              }

              return const Center(child: Text('Data tidak ditemukan'));
          }
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    List<WilayahModel>? listWilayah,
    List<CuacaModel>? listCuaca,
  ) {
    List<WilayahModel>? _currentWilayah = listWilayah!
        .where((WilayahModel element) => element.id == _idWilayah)
        .toList();

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top * 2,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          builder: (_) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Pilih Wilayah',
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: listWilayah.length,
                                    itemBuilder: (context, index) {
                                      WilayahModel item = listWilayah[index];
                                      return ListTile(
                                        title: Text(item.kota!),
                                        visualDensity: VisualDensity.compact,
                                        onTap: () {
                                          Navigator.pop(context);
                                          _idWilayah = item.id!;
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        _currentWilayah.first.propinsi!,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  _currentWilayah.first.kota!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24.0),
                _textWithDerajat(
                  text: MyHelper.getInitialCuaca(listCuaca!).tempC!,
                  textColor: Colors.white,
                  derajatColor: Colors.white,
                  fontSize: 56.0,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 24.0),
                Text(
                  MyHelper.dateToday(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  MyHelper.getInitialCuaca(listCuaca).cuaca!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24.0),
                Image.asset(
                  'assets/images/${MyHelper.getInitialCuaca(listCuaca).kodeCuaca!}.png',
                ),
              ],
            ),
          ),
        ),
        _cuacaSection(listCuaca),
      ],
    );
  }

  Widget _cuacaSection(List<CuacaModel>? listCuaca) {
    List<CuacaModel>? listCuacaToday = listCuaca!
        .where((element) => MyHelper.isToday(element.jamCuaca!))
        .toList();
    List<CuacaModel>? listCuacaTomorrow = listCuaca
        .where((element) => !MyHelper.isToday(element.jamCuaca!))
        .toList();

    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _cuacaTabController,
              labelColor: Colors.black,
              isScrollable: true,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              indicatorColor: Colors.blue,
              tabs: const [Tab(text: 'Hari ini'), Tab(text: 'Besok')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _cuacaTabController,
              children: [
                _listViewCuaca(listCuacaToday),
                _listViewCuaca(listCuacaTomorrow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textWithDerajat({
    required String text,
    Color textColor = Colors.black,
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.w700,
    Color derajatColor = Colors.black,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 8.0,
            width: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: derajatColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listViewCuaca(List<CuacaModel>? list) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (_, index) => const SizedBox(width: 40.0),
      itemCount: list!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 16.0,
      ),
      itemBuilder: (_, index) {
        CuacaModel item = list[index];
        return Column(
          children: [
            Text(
              MyHelper.formatTimeOnly(item.jamCuaca!),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            Image.asset(
              'assets/images/${item.kodeCuaca}.png',
              height: 50.0,
              width: 50.0,
            ),
            const SizedBox(height: 24.0),
            _textWithDerajat(text: item.tempC!),
          ],
        );
      },
    );
  }
}
