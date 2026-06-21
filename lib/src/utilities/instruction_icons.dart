String iconNameForInstruction(String instruction) {
  final text = instruction.toLowerCase();

  if (text.contains('turn sharp left')) return 'turn_sharp_left';
  if (text.contains('turn sharp right')) return 'turn_sharp_right';
  if (text.contains('turn slight left')) return 'turn_slight_left';
  if (text.contains('turn slight right')) return 'turn_slight_right';
  if (text.contains('turn left')) return 'turn_left';
  if (text.contains('turn right')) return 'turn_right';

  if (text.contains('keep left') ||
      text.contains('bear left') ||
      text.contains('fork left')) {
    return 'turn_left';
  }
  if (text.contains('keep right') ||
      text.contains('bear right') ||
      text.contains('fork right')) {
    return 'turn_right';
  }

  if (text.contains('keep straight') || text.contains('continue straight')) {
    return 'arrow_upward';
  }
  if (text.contains('continue')) return 'arrow_upward';
  if (text.contains('head')) return 'near_me';

  if (text.contains('arrive') ||
      text.contains('destination') ||
      text.contains('finish')) {
    return 'location_on';
  }

  if (text.contains('roundabout')) return 'autorenew';
  if (text.contains('merge')) return 'merge_type';

  if (text.contains('uturn') ||
      text.contains('u-turn') ||
      text.contains('make a u')) {
    return 'autorenew';
  }

  if (text.contains('ramp')) return 'motorcycle_outlined';
  if (text.contains('exit')) return 'exit_to_app';

  return 'navigation';
}
