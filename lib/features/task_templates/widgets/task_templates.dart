import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/features/store_report/store_report.dart';
import 'package:pondrop/features/store_submission/store_submission.dart';

import '../bloc/task_templates_bloc.dart';

class TaskTemplates extends StatelessWidget {
  const TaskTemplates({Key? key, required this.visit, required this.store})
      : super(key: key);

  final StoreVisitDto visit;
  final Store store;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<TaskTemplatesBloc>()
          ..add(const TaskTemplatesRefreshed());
        return bloc.stream
            .firstWhere((e) => e.status != TaskTemplateStatus.refreshing);
      },
      child: BlocBuilder<TaskTemplatesBloc, TaskTemplatesState>(
        buildWhen: (previous, current) =>
            current.status != TaskTemplateStatus.refreshing,
        builder: (context, state) {
          if (state.status == TaskTemplateStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TaskTemplateStatus.failure ||
              state.templates.isEmpty) {
            return _noTasksFound();
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final item = state.templates[index];
              return StoreTaskListItem(
                  submissionTemplate: item,
                  onTap: () async {
                    Navigator.of(context).pop();

                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => StoreSubmissionPage(
                        visit: visit,
                        submission: item.toStoreSubmission(
                            storeVisit: visit, store: store, campaignId: null),
                      ),
                      enableDrag: false,
                    );
                  });
            },
            itemCount: state.templates.length,
          );
        },
      ),
    );
  }

  Widget _noTasksFound() {
    return LayoutBuilder(builder: (context, constraints) {
      final l10n = context.l10n;
      return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child:
                Center(child: Text(l10n.noItemFound(l10n.tasks.toLowerCase()))),
          ));
    });
  }
}
