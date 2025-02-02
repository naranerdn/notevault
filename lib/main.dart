import 'package:flutter/material.dart';
import 'customer.dart';
import 'item.dart';
import 'login_signup.dart';
import 'order.dart';

void main() {
  runApp(MyLoginAndSignUp());
}

//'_items' object -үүдийн жагсаалтыг үүсгэдэг.(хоолны жагсаалтын үүсгэж байгаа хэсэг)
const List<Item> _items = [
  Item(
    name: 'Самгёбсал',
    totalPriceCents: 44800,
    uid: '1',
    imageProvider: AssetImage('assets/h1.jpg'),
  ),
  Item(
    name: 'Керан Мари',
    totalPriceCents: 10800,
    uid: '2',
    imageProvider: AssetImage('assets/h2.jpg'),
  ),
  Item(
    name: 'Дүпү кимчи',
    totalPriceCents: 26800,
    uid: '3',
    imageProvider: AssetImage('assets/h3.jpg'),
  ),
  Item(
    name: 'Жэюүг',
    totalPriceCents: 31800,
    uid: '4',
    imageProvider: AssetImage('assets/h4.jpg'),
  ),
  Item(
    name: 'Бибимбаб',
    totalPriceCents: 22800,
    uid: '5',
    imageProvider: AssetImage('assets/h5.jpg'),
  ),
  Item(
    name: 'Гунчи кимчи',
    totalPriceCents: 25800,
    uid: '6',
    imageProvider: AssetImage('assets/h6.jpg'),
  ),
  Item(
    name: 'Су Калби',
    totalPriceCents: 40800,
    uid: '7',
    imageProvider: AssetImage('assets/h7.jpg'),
  ),
  Item(
    name: 'Кимбаб',
    totalPriceCents: 10800,
    uid: '8',
    imageProvider: AssetImage('assets/h8.jpg'),
  ),
];

// @immutable нь виджет өөрөө өөрчлөгдөхгүй гэдгийг харуулж байна
// `ExampleDragAndDrop` нэртэй төлөвтэй виджетийг тодорхойлж байна
@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({Key? key}) : super(key: key);

  //createState method-г тодорхойлж байна
  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

//ExampleDragAndDrop` виджетийн төлөвийн class - г тодорхойлж бна
class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  // Customer class- хэрэглэгчийн жагсаалтыг үүсгэж байна
  final List<Customer> _people = [
    Customer(
      name: 'Makayla',
      imageProvider: const AssetImage('assets/person.png'),
    ),
  ];

//Энэхүү кодын мөр нь виджетийн модны виджетийг өвөрмөц байдлаар тодорхойлоход хэрэглэгддэг '_draggableKey' нэртэй 'GlobalKey'-г зарладаг. `GlobalKey`-ийг Flutter-д ихэвчлэн хөдөлгөөнт дүрс, фокусын удирдлага эсвэл маягтын талбартай ажиллах зэрэг виджетийн гаднаас тодорхой виджетийн төлөв эсвэл шинж чанарт хандах шаардлагатай үед ашигладаг.

//Төлвийг удирдах эсвэл хэрэглэгчийн интерфейсийг шинэчлэхэд ашигладаг.
  final GlobalKey _draggableKey = GlobalKey();

//энэ method-г хэрэглэгчийн сагсанд бараа буулгах үед дууддаг.
  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    //"setState" нь "ExampleDragAndDrop" виджетийн төлөвийг шинэчлэхийн тулд дуудагддаг.
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFFF64209)),
      title: Text(
        'Order Food',
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 36,
              color: const Color(0xFFF64209),
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      elevation: 0,
    );
  }

// menu-n jagsaalt uusgedg humuusin egnee (stack ) uusgedg
  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildPeopleRow(),
            ],
          ),
        ),
      ],
    );
  }

//энэ арга нь item-уудыг гүйлгэх боломжтой жагсаалтыг үүсгэдэг бөгөөд чирэх боломжтой.
  Widget _buildMenuList() {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 12,
          );
        },
        itemBuilder: (context, index) {
          final item = _items[index];
          return _buildMenuItem(
            item: item,
          );
        },
      );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable<Item>(
      key: ValueKey(item.uid),
      data: item,
      childWhenDragging: const SizedBox.shrink(),
      feedback: DraggingListItem(
        dragKey: _draggableKey,
        photoProvider: item.imageProvider,
      ),
      child: MenuListItem(
        name: item.name,
        price: item.formattedTotalItemPrice,
        photoProvider: item.imageProvider,
      ),
    );
  }

//энэ арга нь үйлчлүүлэгчдийн эгнээ үүсгэдэг, тус бүр нь чирсэнийг buildPersonWithDropZone оруулна.
  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Row(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

//Энэ арга нь худалдан авагч бүрийн хувьд буулгах боломжтой хэсгийг үүсгэж, хоолнуудыг
// сагсанд нь чирж, буулгах боломжийг олгодог төлөв болон UI-г шинэчилдэг.
  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        child: DragTarget<Item>(
          builder: (context, candidateItems, rejectedItems) {
            return CustomerCart(
              hasItems: customer.items.isNotEmpty,
              highlighted: candidateItems.isNotEmpty,
              customer: customer,
            );
          },
          onAcceptWithDetails: (details) {
            _itemDroppedOnCustomerCart(
              item: details.data,
              customer: customer,
            );
          },
        ),
      ),
    );
  }
}

//
class CustomerCart extends StatelessWidget {
  const CustomerCart({
    Key? key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  }) : super(key: key);

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderPage(selectedItems: customer.items)));
      },
      child: Transform.scale(
        scale: highlighted ? 1.075 : 1.0,
        child: Material(
          elevation: highlighted ? 8 : 4,
          borderRadius: BorderRadius.circular(22),
          color: highlighted ? const Color(0xFFF64209) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 46,
                    height: 46,
                    child: Image(
                      image: customer.imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  customer.name,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: textColor,
                        fontWeight:
                            hasItems ? FontWeight.normal : FontWeight.bold,
                      ),
                ),
                Visibility(
                  visible: hasItems,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        customer.formattedTotalItemPrice,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${customer.items.length} item${customer.items.length != 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: textColor,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//MenuListItem нь хүнсний барааны зураг, нэр, үнийг картын форматаар харуулдаг дахин ашиглах боломжтой виджет бөгөөд тухайн зүйлийг чирж байх үед animation үзүүлдэг.
class MenuListItem extends StatelessWidget {
  const MenuListItem({
    Key? key,
    this.name = '',
    this.price = '',
    required this.photoProvider,
    this.isDepressed = false,
  }) : super(key: key);

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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

//DraggingListItem нь чирсэн зүйлийг харуулахад ашигладаг
class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    Key? key,
    required this.dragKey,
    required this.photoProvider,
  }) : super(key: key);

  final GlobalKey
      dragKey; //GlobalKey нь чирсэн зүйлийн виджетийг тодорхойлоход хэрэглэгддэг.
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
