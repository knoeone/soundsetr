part of 'soundset.dart';

createNewSoundSet(name) {
  var cleanName = sanitizeFilename(name);
  final destinationFile = SoundSet.createSoundsetPathByName(cleanName);

  Directory(destinationFile).createSync();

  var plist = """
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>SoundSetFileFormatVersion</key>
    <integer>0</integer>
    <key>SoundSetUserString</key>
    <string>Created by Soundsetr</string>
    <key>SoundSetURL</key>
    <string>http://www.microsoft.com/mac</string>
    <key>SoundFile_MailError</key>
    <string>mailerror.wav</string>
    <key>SoundFile_MailSent</key>
    <string>mailsent.wav</string>
    <key>SoundFile_NewMail</key>
    <string>newmail.wav</string>
    <key>SoundFile_NoMail</key>
    <string>nomail.wav</string>
    <key>SoundFile_Reminder</key>
    <string>reminder.wav</string>
    <key>SoundFile_Welcome</key>
    <string>welcome.wav</string>
  </dict>
  </plist>
  """;

  File(p.join(destinationFile, 'soundset.plist')).writeAsStringSync(plist);
}
