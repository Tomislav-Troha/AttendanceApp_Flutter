import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class MultiMemberChoice extends StatelessWidget {
  const MultiMemberChoice({
    super.key,
    required this.valueMember,
    required this.showMultiMembers,
  });

  final List<UserResponseModel> valueMember;
  final void Function() showMultiMembers;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: valueMember.isNotEmpty,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 13),
            decoration: BoxDecoration(
              border: Border.all(),
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: InkWell(
              onTap: showMultiMembers,
              child: Wrap(
                children: valueMember
                    .map((e) => Container(
                          padding: const EdgeInsets.only(top: 3),
                          margin: const EdgeInsets.all(5),
                          child: Chip(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            label: Text("${e.name!} ${e.surname!}"),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.supervised_user_circle_outlined,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
