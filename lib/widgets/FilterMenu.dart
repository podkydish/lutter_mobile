/*
class MyPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Container(
            width: 200, // Ширина PopupMenu
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text('Элемент 1'),
                  onTap: () {
                    // Действие при выборе элемента 1
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Элемент 2'),
                  onTap: () {
                    // Действие при выборе элемента 2
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Открыть PopupMenu'),
      ),
    );
  }
}
*/
