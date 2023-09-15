import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../bloc/task_templates_bloc.dart';
import '../widgets/task_templates.dart';

class TaskTemplatesPage extends StatelessWidget {
  const TaskTemplatesPage({Key? key, required this.visit, required this.store})
      : super(key: key);

  static Route route(StoreVisitDto visit, Store store) {
    return RouteTransitions.modalSlideRoute(
        pageBuilder: (_) => TaskTemplatesPage(
              visit: visit,
              store: store,
            ));
  }

  final StoreVisitDto visit;
  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => TaskTemplatesBloc(
        submissionRepository:
            RepositoryProvider.of<SubmissionRepository>(context),
      )..add(const TaskTemplatesFetched()),
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Text(
                l10n.selectAItem(l10n.task),
                style: PondropStyles.appBarTitleTextStyle,
              ),
              centerTitle: true,
              leading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })),
          body: Builder(builder: (context) {
            return TaskTemplates(
              visit: visit,
              store: store,
            );
          })),
    );
  }
}
