import 'package:collection/collection.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/search/tune.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:demoapp/view/mainApp/search/viewSkill.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SkillsSearch extends SearchDelegate<Skill> {
  final UnmodifiableListView<Skill> skills;

  //BuildContext _context;

  SkillsSearch(this.skills);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  BuildContext _context;

  DialogLoading dialogLoading;

  @override
  Widget buildResults(BuildContext context) {
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    var results =
        skills.where((a) => a.name.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      //todo ________
      children: results
          .map<ListTile>((a) => ListTile(
                title: Text(a.name,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 16.0)),
                leading: Icon(Icons.remove_red_eye_outlined),
                // написать страницу просмотра навыка
                onTap: () async {
                  dialogLoading.show();
                  Skill skill;
                  Api.getSkill(a.id)
                      .then((value) => {
                            if (value.isSuccess())
                              {
                              dialogLoading.stop(),
                                skill = value.getData(),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new ViewSkill(skill: skill))),
                              }
                            else
                              {
                              dialogLoading.stop(),
                                Error.errorSnackBar(globalKey)
                              }
                          })
                      .timeout(Duration(seconds: 90))
                      .catchError((Object object) => {
                          dialogLoading.stop(),
                            Error.errorSnackBar(globalKey)
                          });
                  close(context, a);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results =
        skills.where((a) => a.name.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      //todo ________
      children: results
          .map<ListTile>((a) => ListTile(
                title: Text(a.name,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 16.0,
                          color: Colors.blue,
                        )),
                onTap: () {
                  close(context, a);
                },
              ))
          .toList(),
    );
  }
}
