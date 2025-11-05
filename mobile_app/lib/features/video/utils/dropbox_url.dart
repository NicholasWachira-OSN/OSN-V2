String toDropboxDirectUrl(String input) {
  try {
    final uri = Uri.parse(input);
    const host = 'dl.dropboxusercontent.com';
    final qp = Map<String, String>.from(uri.queryParameters);
    qp['dl'] = '1';
    return Uri(
      scheme: 'https',
      host: host,
      path: uri.path,
      queryParameters: qp.isEmpty ? null : qp,
    ).toString();
  } catch (_) {
    return input;
  }
}
