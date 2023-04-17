import 'package:flutter/material.dart';
import 'package:resep_makanan/view/style/theme.dart';
import 'package:resep_makanan/view/tambah_resep.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 48,
          width: 280,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: "Cari resep yang sudah kamu tulis...",
              hintStyle: greyFontStyle.copyWith(fontSize: 10),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahResep(),
              ),
            );
          },
          icon: const Icon(
            Icons.library_add,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
