import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.showSettings) {
          return SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: appState.currentTheme.textColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _NavButton(
                      label: 'Goals',
                      isActive: appState.activeTab == ActiveTab.goals,
                      onPressed: () =>
                          appState.setActiveTab(ActiveTab.goals),
                    ),
                  ),
                  Expanded(
                    child: _NavButton(
                      label: 'Atmosphere',
                      isActive: appState.activeTab == ActiveTab.atmosphere,
                      onPressed: () =>
                          appState.setActiveTab(ActiveTab.atmosphere),
                    ),
                  ),
                ],
              ),
            ),
            // Content based on active tab
            if (appState.activeTab == ActiveTab.goals)
              _GoalsPanel()
            else
              _AtmospherePanel(),
          ],
        );
      },
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? appState.currentTheme.accentColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive
                    ? appState.currentTheme.accentColor
                    : appState.currentTheme.textColor.withValues(alpha: 0.6),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalsPanel extends StatelessWidget {
  const _GoalsPanel();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          color: appState.currentTheme.backgroundColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                for (final goal in appState.goals)
                  _GoalItem(
                    goal: goal,
                    isActive: appState.activeGoalId == goal.id,
                    onTap: () => appState.setActiveGoal(goal.id),
                    onDelete: () => appState.deleteGoal(goal.id),
                  ),
                SizedBox(height: 12),
                if (!appState.showGoalInput)
                  _AddGoalButton(
                    onPressed: appState.toggleGoalInput,
                  )
                else
                  _AddGoalInput(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GoalItem extends StatelessWidget {
  final Goal goal;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GoalItem({
    required this.goal,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive
                ? appState.currentTheme.accentColor
                : appState.currentTheme.textColor.withValues(alpha: 0.2),
            width: isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? appState.currentTheme.accentColor.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            if (isActive)
              Icon(
                Icons.check_circle,
                color: appState.currentTheme.accentColor,
                size: 20,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: appState.currentTheme.textColor.withValues(alpha: 0.5),
                size: 20,
              ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: TextStyle(
                      color: appState.currentTheme.textColor,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${goal.secondsSpent ~/ 3600}h ${(goal.secondsSpent % 3600) ~/ 60}m',
                    style: TextStyle(
                      color: appState.currentTheme.textColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: appState.currentTheme.textColor.withValues(alpha: 0.5),
                size: 18,
              ),
              onPressed: onDelete,
              constraints: BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGoalButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddGoalButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: appState.currentTheme.textColor.withValues(alpha: 0.3),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: appState.currentTheme.accentColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Add Goal',
              style: TextStyle(
                color: appState.currentTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGoalInput extends StatefulWidget {
  const _AddGoalInput();

  @override
  State<_AddGoalInput> createState() => _AddGoalInputState();
}

class _AddGoalInputState extends State<_AddGoalInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _controller = TextEditingController(text: appState.newGoalTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: appState.currentTheme.accentColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: appState.setNewGoalTitle,
            decoration: InputDecoration(
              hintText: 'Goal name',
              hintStyle: TextStyle(
                color: appState.currentTheme.textColor.withValues(alpha: 0.4),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: TextStyle(
              color: appState.currentTheme.textColor,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: appState.toggleGoalInput,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: appState.currentTheme.textColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _controller.text.isNotEmpty
                    ? () {
                        appState.addGoal(_controller.text);
                        _controller.clear();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appState.currentTheme.accentColor,
                  foregroundColor: appState.currentTheme.backgroundColor,
                  disabledBackgroundColor: appState.currentTheme.accentColor
                      .withValues(alpha: 0.4),
                ),
                child: Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AtmospherePanel extends StatelessWidget {
  const _AtmospherePanel();

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Container(
      color: appState.currentTheme.backgroundColor,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Currently Playing',
            style: TextStyle(
              color: appState.currentTheme.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: appState.currentTheme.textColor.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              appState.currentSound?.name ?? 'No sound',
              style: TextStyle(
                color: appState.currentTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
