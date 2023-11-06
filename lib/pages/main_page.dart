import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:xleb/data/article.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Article> articles = [];
  String page = 'main';

  @override
  void initState() {
    getWebsiteData('https://hip.kz/index.php?route=common/home');

    super.initState();
  }

  Future getWebsiteData(String urlString) async {
    getWebsiteData;
    final url = Uri.parse(urlString);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('  h4 > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    final prices = html
        .getElementsByClassName('price')
        .map((e) => e.innerHtml.trim())
        .toList();

    final urlImages = html
        .querySelectorAll('div > div.image > a > img')
        .map((e) => e.attributes['src']!)
        .toList();

    final descriptions = html
        .querySelectorAll(' div > div.caption > p')
        .map((e) => e.innerHtml.trim())
        .where((e) => (e.toString().length > 10))
        .toList();

    setState(
      () {
        articles = List.generate(
          titles.length,
          (index) => Article(
            desc: descriptions[index],
            title: titles[index],
            price: prices[index],
            urlImage: urlImages[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Главная страница',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Настройки',
            icon: Icon(Icons.settings),
          )
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Хлеб и Пирог'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    if (page != 'main') {
                      setState(() {
                        getWebsiteData(
                            'https://hip.kz/index.php?route=common/home');
                        page = 'main';
                      });
                    }
                  },
                  child: const Text('Главное')),
              TextButton(
                  onPressed: () {
                    if (page != 'pies') {
                      setState(() {
                        getWebsiteData(
                            'https://hip.kz/index.php?route=product/category&path=99');
                      });
                      page = 'pies';
                    }
                  },
                  child: const Text('Пироги сытные'))
            ],
          ),
          SizedBox(
            height: 620,
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return SizedBox(
                  height: 150,
                  child: ListTile(
                    subtitle: Text(article.desc),
                    title: Text('${article.title}   ${article.price}'),
                    leading: Image.network(
                      article.urlImage,
                      height: 100,
                      width: 100,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
