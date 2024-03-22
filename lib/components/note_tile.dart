import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import 'note_settings.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? editPressed;
  final void Function()? deletePressed;
  const NoteTile(
      {super.key, this.editPressed, this.deletePressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: ListTile(
        title: Text(text),
        trailing: Builder(builder: (context) {
          return IconButton(
              onPressed: () => showPopover(
                  width: 100,
                  height: 100,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  context: context,
                  bodyBuilder: (context) => NoteSettings(
                        onEditTap: editPressed,
                        onDeleteTap: deletePressed,
                      )),
              icon: const Icon(Icons.more_vert));
        }),
      ),
    );
  }
}
