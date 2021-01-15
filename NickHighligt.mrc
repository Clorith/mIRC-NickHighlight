dialog NickHighlight_add {
  title "NickHighlight Nick/Word Adder"
  size -1 -1 271 112
  option pixels
  text "New Word/Nick/Phrase to add:", 1, 8 15 149 16
  box "Word", 2, 3 0 265 40
  edit "", 3, 159 13 105 21, autohs
  box "Sound", 4, 3 40 265 41
  text "Highlight sound:", 5, 10 56 78 16
  edit "", 6, 90 54 140 21
  button "...", 7, 234 55 20 20
  button "Add", 8, 55 85 75 25
  button "Cancel", 9, 145 85 75 25, cancel
}
dialog NickHighlight2 {
  title "NickHighlight Extended Information"
  size -1 -1 170 126
  option dbu

  box "Nickname", 1, 47 -1 67 19
  edit "", 2, 52 7 59 10, read center

  box "Address", 3, 0 17 170 33
  edit "", 4, 8 24 155 10, read autohs center
  combo 5, 85 36 60 60, size drop
  text "Address format:", 6, 38 38 39 8

  box "Time", 7, 86 85 84 40
  combo 9, 118 111 50 50, size drop
  edit "", 10, 104 95 50 10, read center
  text "TimeZone :", 8, 89 112 27 8

  box "Message", 11, 0 50 170 35
  edit "", 12, 2 57 165 26, read multi autovs vsbar

  box "Other Information", 13, 0 85 86 41
  text "Server :", 14, 4 115 20 8
  text "Network :", 15, 4 105 24 8
  text "Channel :", 16, 4 95 23 8
  edit "", 17, 32 114 50 10, read autohs center
  edit "", 18, 32 104 50 10, read autohs center
  edit "", 19, 32 94 50 10, read autohs center
}
dialog NickHighlight {
  title "Nickname highlighter v4.0"
  size -1 -1 430 315
  option pixels
  button "Options", 1, 176 290 50 20
  list 2, 0 0 430 290
  button "Clear Highlights", 3, 75 290 100 20
  button "Restore History", 4, 226 290 100 20
  button "List All ", 5, 126 268 75 20
  button "List X", 7, 202 268 75 20
}
dialog NickHighlight_options {
  title "Nickname Highlighter Options"
  size -1 -1 435 280
  option pixels
  box "Trigger when mIRC is...", 1, 0 0 178 65
  check "Minimized", 2, 3 33 70 13, disable
  check "In Tray", 3, 103 31 70 13, disable
  check "Maximized", 4, 3 47 70 13, disable
  check "Other", 5, 103 47 70 13, disable
  check "Enable sounds?", 6, 38 82 100 13
  check "", 7, 5 210 15 23
  box "Sounds", 9, 0 64 178 107
  radio "Standar beep", 10, 7 97 100 20, disable
  radio "Custom Sound", 11, 7 115 100 20, disable
  edit "", 12, 25 137 115 21, disable autohs
  button "...", 13, 144 135 25 25, disable flat
  box "Other", 14, 0 170 178 70
  box "Response nicks/words", 15, 180 0 255 140
  list 16, 184 16 135 121, sort size
  button "Add To List", 17, 327 20 100 50, multi
  button "Remove From List", 18, 327 79 100 50, multi
  check "Activate NickHighlight", 19, 25 16 125 13
  box "Backups", 20, 0 240 178 40
  check "Backup Highlights when cleared", 21, 5 255 170 20
  check "", 22, 5 183 15 24
  text "Keep NickHighligter hidden when triggered.", 23, 21 182 135 26
  text "Place NickHighlighter on top of other programs?", 8, 21 210 135 26
  box "Ignore Settings", 24, 180 141 255 139
  list 25, 184 156 135 121, size
  button "Add To List", 26, 327 161 100 50
  button "Remove From List", 27, 327 220 100 50
}
alias ignoreNickHighlight {
  var %NHini = $shortfn($scriptdirNH\NH_Ignore.ini)
  var %a = 1
  var %nhig = no
  while (%a <= $ini(%NHini,0)) {
    if (($ini(%NHini,%a) == $1) || ($ini(%NHini,%a) == $2)) { %nhig = yes | inc %a $ini(%NHini,0) }
    else { inc %a 1 }
  }
  return %nhig
}
alias NH_addignore {
  var %nh_ig  $$?="Enter a channel/nick to ignore (use 'NOTICE' to ignore notices)"
  .writeini -n $shortfn($scriptdirNH\NH_Ignore.ini) %nh_ig added $fulldate
  .dialog -vo NickHighlight_options
}
alias reloadNickHighlight {
  if ($1 == all) {
    if ($ini(NickHighlight.ini,0) >= 100) {
      var %nh_lcheck = $input(NickHighlight,yv,There are a total of $ini(NickHighlight.ini,0) highlights $+ $clrf $+ Are you sure you wish to list them all?)
      if (%nh_lcheck == $no) { halt }
    }
    var %a = 1
    var %end = $ini(NickHighlight.ini,0)
  }
  else {
    var %init = $$?="Enter which highlights to show: $+ $crlf $+ (Example: 1-10) - (Total: $ini(NickHighlight.ini,0) $+ )"
    .dialog -v NickHighlight
    if ($numtok(%init,45) < 1) {
      halt
    }
    else {
      var %a = $gettok(%init,1,45)
      var %end = $gettok(%init,2,45)
      if ($numtok(%init,45) < 2) {
        var %end = %a
        var %a = 1
      }
    }
  }
  .did -r NickHighlight 2
  while (%a <= %end) {
    .did -a NickHighlight 2 $ini(NickHighlight.ini,%a) $chr(9) $readini(NickHighlight.ini, $ini(NickHighlight.ini, %a), Nick) $chr(9) $readini(NickHighlight.ini, $ini(NickHighlight.ini, %a), Time) $chr(9) $readini(NickHighlight.ini, $ini(NickHighlight.ini, %a), Channel) $chr(9) $readini(NickHighlight.ini, $ini(NickHighlight.ini, %a), Msg)
    inc %a
  }
}

on *:DIALOG:NickHighlight_options:sclick:10: {
  if ($did($dname,16).seltext == $null) { halt }
  .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,16).seltext Sound Beep
}
on *:DIALOG:NickHighlight_options:sclick:16: {
  if ($did($dname,16).seltext == $null) { halt }
  .did -ra $dname 12 $readini($shortfn($scriptdirNH\NickHighlight2.ini), $did($dname,16).seltext, Sound)
}
on *:DIALOG:NickHighlight_add:sclick:8: {
  if ($did($dname,3).text == $null) {
    halt
  }
  .did -a NickHighlight_options 16 $did($dname,3).text
  .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,3).text nick Created
  if ($did($dname,6).text == $null) { .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,3).text Sound None }
  else { .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,3).text Sound $did($dname,6).text }
  .dialog -x $dname $dname
}
on *:DIALOG:NickHighlight_options:edit:12: {
  if ($did($dname,16).seltext == $null) { halt }
  if ($did($dname,12).text == $null) { .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,16).seltext Sound None | halt }
  .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,16).seltext Sound $did($dname,12).text
}
on *:DIALOG:NickHighlight_add:sclick:7: {
  .set %NH_temp $sfile(C:\,$did($dname,2) Sound)
  if (%NH_temp == $null) { halt }
  .did -ra $dname 6 %NH_temp
}
on *:DIALOG:NickHighlight_options:sclick:19: {
  if ($did($dname,19).state == 1) { .did -e $dname 2,3,4,5 | .set %NickHighlight_mode on }
  else { .did -b $dname 2,3,4,5 | .set %NickHighlight_mode off }
}
on *:DIALOG:NickHighlight_options:sclick:18: {
  if ($did($dname,16).seltext == $null) { halt }
  .remini $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,16).seltext
  .did -r $dname 16 
  var %a = 1
  while (%a <= $ini($shortfn($scriptdirNH\NickHighlight2.ini),0)) {
    .did -a $dname 16 $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a)
    inc %a
  }
}
on *:DIALOG:NickHighlight_options:sclick:17: {
  .dialog -mdo NickHighlight_add NickHighlight_add
}
on *:DIALOG:NickHighlight_options:sclick:13: {
  .set %NickHighlight_soundfile $sfile(C:\,NickHighlight sound)
  if (%NickHighlight_soundfile == $null) { .did -c $dname 10 | .did -b $dname 12,13 | halt }
  .set %NickHighlight_selfsound yes
  .did -ra $dname 12 %NickHighlight_soundfile
  .writeini -n $shortfn($scriptdirNH\NickHighlight2.ini) $did($dname,16).seltext Sound %NickHighlight_soundfile
}
on *:DIALOG:NickHighlight:sclick:5: {
  .reloadNickHighlight all
}
on *:DiALOG:NickHighlight:sclick:7: {
  .reloadNickHighlight
}
on *:DIALOG:NickHighlight:sclick:4: {
  if (!$exists(NHBackup.ini)) { halt }
  var %a = 1
  while (%a <= $ini(NHBackup.ini,0)) {
    .writeini -n NickHighlight.ini %a Nick $readini(NHBackup.ini,%a,Nick)
    .writeini -n NickHighlight.ini %a Msg $readini(NHBackup.ini,%a,Msg)
    .writeini -n NickHighlight.ini %a *!user@host $readini(NHBackup.ini,%a,*!user@host)
    .writeini -n NickHighlight.ini %a *!*user@host $readini(NHBackup.ini,%a,*!*user@host)
    .writeini -n NickHighlight.ini %a *!*@host $readini(NHBackup.ini,%a,*!*@host)
    .writeini -n NickHighlight.ini %a *!*user@*.host $readini(NHBackup.ini,%a,*!*user@*.host)
    .writeini -n NickHighlight.ini %a *!*@*.host $readini(NHBackup.ini,%a,*!*@*.host)
    .writeini -n NickHighlight.ini %a nick!user@host $readini(NHBackup.ini,%a,nick!user@host)
    .writeini -n NickHighlight.ini %a nick!*user@host $readini(NHBackup.ini,%a,nick!*user@host)
    .writeini -n NickHighlight.ini %a nick!*@host $readini(NHBackup.ini,%a,nick!*@host)
    .writeini -n NickHighlight.ini %a nick!*user@*.host $readini(NHBackup.ini,%a,nick!*user@*.host)
    .writeini -n NickHighlight.ini %a nick!*@*.host $readini(NHBackup.ini,%a,nick!*@*.host)
    .writeini -n NickHighlight.ini %a Time $readini(NHBackup.ini,%a,Time)
    .writeini -n NickHighlight.ini %a Server $readini(NHBackup.ini,%a,Server)
    .writeini -n NickHighlight.ini %a Network $readini(NHBackup.ini,%a,Network)
    .writeini -n NickHighlight.ini %a Channel $readini(NHBackup.ini,%a,Channel)
    inc %a
  }
}

on *:DIALOG:NickHighlight:sclick:3: {
  if (%NickHighlight_backup == yes) {
    if ($exists(NHBackup.ini)) { .remove NHBackup.ini }
    var %a = 1
    while (%a <= $lines(NickHighlight.ini)) {
      .write NHBackup.ini $read(NickHighlight.ini,%a)
      inc %a
    }
  }
  .remove NickHighlight.ini
  .did -r $dname 2
}
on *:DIALOG:NickHighlight2:init:0: {
  .did -a $dname 5 *!user@host
  .did -a $dname 5 *!*user@host
  .did -a $dname 5 *!*@host
  .did -a $dname 5 *!*user@*.host
  .did -a $dname 5 *!*@*.host
  .did -a $dname 5 nick!user@host
  .did -a $dname 5 nick!*user@host
  .did -a $dname 5 nick!*@host
  .did -a $dname 5 nick!*user@*.host
  .did -a $dname 5 nick!*@*.host
  .did -c $dname 5 1
  .did -a $dname 2 $readini(NickHighlight.ini, %NH_details, Nick)
  .did -a $dname 4 $readini(NickHighlight.ini, %NH_details, *!user@host)
  .did -a $dname 10 $readini(NickHighlight.ini, %NH_details, Time)
  .did -a $dname 12 $readini(NickHighlight.ini, %NH_details, Msg)
  .did -a $dname 17 $readini(NickHighlight.ini, %NH_details, Server)
  .did -a $dname 18 $readini(NickHighlight.ini, %NH_details, Network)
  .did -a $dname 19 $readini(NickHighlight.ini, %NH_details, Channel)
  .set %NH_extendnfo %a
  inc %a
  var %b = -12
  while (%b <= 12) {
    .did -a $dname 9 GMT %b
    inc %b
  }
  .set %NH_temp 1
  var %c = -12
  while (%c <= 12) {
    if ($remove($time(z),+) == %c) { .did -c $dname 9 %NH_temp | inc %c }
    inc %NH_temp
    inc %c
  }
}
on *:DIALOG:NickHighlight2:sclick:9: {
  .set %NH_tmp $ctime($date $readini(NickHighlight.ini, %NH_extendnfo, Time))
  if ($did($dname,9).seltext == GMT 0) {
    .set %NH_tmp $calc(%NH_tmp + ($timezone))
    .did -ra $dname 10 $asctime(%NH_tmp,hh:nn:ss)
    halt
  }
  if ($right($left($did($dname,9).seltext,5),1) == $chr(45)) {
    .set %NH_tmp $calc(%NH_tmp - (3600 * $remove($did($dname,9).seltext,$chr(45),GMT,$chr(32))))
    .did -ra $dname 10 $asctime(%NH_tmp,hh:nn:ss)
    halt  
  }
  else {
    .set %NH_tmp $calc(%NH_tmp + (3600 * $remove($did($dname,9).seltext,GMT,$chr(32))))
    .did -ra $dname 10 $asctime(%NH_tmp,hh:nn:ss)
    halt  
  }
}
on *:DIALOG:NickHighlight2:sclick:5: {
  .did -ra $dname 4 $readini($shortfn(NickHighlight.ini), %NH_details, $did($dname,5).seltext)
}
on *:DIALOG:NickHighlight:dclick:2: {
  .set %NH_details $gettok($did($dname,2).seltext,1,32)
  .dialog -mdo NickHighlight2 NickHighlight2
}
on *:DIALOG:NickHighlight_options:sclick:2,3,4,5,6,7,10,11,21: {
  if ($did == 2) {
    if ($did($dname,2).state == 1) { .set %NickHighlight_AppState %NickHighlight_AppState minimized }
    else { .set %NickHighlight_AppState $remove(%NickHighlight_AppState,minimized) }
  }
  if ($did == 3) {
    if ($did($dname,3).state == 1) { .set %NickHighlight_AppState %NickHighlight_AppState tray }
    else { .set %NickHighlight_AppState $remove(%NickHighlight_AppState,tray) }
  }
  if ($did == 4) {
    if ($did($dname,4).state == 1) { .set %NickHighlight_AppState %NickHighlight_AppState maximized }
    else { .set %NickHighlight_AppState $remove(%NickHighlight_AppState,maximized) }
  }
  if ($did == 5) {
    if ($did($dname,5).state == 1) { .set %NickHighlight_AppState %NickHighlight_AppState normal }
    else { .set %NickHighlight_AppState $remove(%NickHighlight_AppState,normal) }
  }
  if ($did == 6) {
    if ($did($dname,6).state == 1) { .set %NickHighlight_sound On | .did -e $dname 10,11 | if (%NickHighlight_selfsound != Yes) { .did -c $dname 10 } | else { .did -c $dname 11 | .did -a $dname 12 %NickHighlight_soundfile } }
    else { .set %NickHighlight_sound Off | .did -b $dname 10,11,12,13 }
  }
  if ($did == 7) {
    if ($did($dname,7).state == 1) { .set %NickHighlight_ontop Yes }
    else { .set %NickHighlight_ontop No }
  }
  if ($did == 10) {
    .did -b $dname 12,13
    .set %NickHighlight_selfsound No
  }
  if ($did == 11) {
    .did -e $dname 12,13
    if (%NickHighlight_selfsound == Yes) { .did -a $dname 12 %NickHighlight_soundfile }
  }
  if ($did == 21) {
    if ($did($dname,21).state == 1) { .set %NickHighlight_backup yes }
    else { .set %NickHighlight_backup no }
  }
}
on *:DIALOG:NickHighlight_options:sclick:26,27: {
  if ($did == 26) {
    .dialog -n $dname
    .NH_addignore
    .did -r $dname 25
    var %a = 1
    while (%a <= $ini($shortfn($scriptdirNH\NH_Ignore.ini),0)) {
      .did -a $dname 25 $ini($shortfn($scriptdirNH\NH_Ignore.ini),%a)
      inc %a
    }    
  }
  if ($did == 27) {
    if (!$did($dname,25).seltext) { halt }
    .remini $shortfn($scriptdirNH\NH_Ignore.ini) $did($dname,25).seltext
    .did -r $dname 25
    var %a = 1
    while (%a <= $ini($shortfn($scriptdirNH\NH_Ignore.ini),0)) {
      .did -a $dname 25 $ini($shortfn($scriptdirNH\NH_Ignore.ini),%a)
      inc %a
    }
  }
}
on *:DIALOG:NickHighlight_options:sclick:22: {
  if ($did($dname,22).state == 1) { .set %NickHighlight_hidden Yes | .did -b $dname 7 }
  else { .set %NickHighlight_hidden No | .did -e $dname 7 }
}
on *:DIALOG:NickHighlight_options:init:0: {
  if (minimized isin %NickHighlight_AppState) { .did -c $dname 2 }
  if (tray isin %NickHighlight_AppState) { .did -c $dname 3 }
  if (maximized isin %NickHighlight_AppState) { .did -c $dname 4 }
  if (Normal isin %NickHighlight_AppState) { .did -c $dname 5 }
  if (%NickHighlight_backup == Yes) { .did -c $dname 21 }
  if (%NickHighlight_sound == On) { 
    .did -c $dname 6 
    .did -e $dname 10,11
    if (%NickHighlight_selfsound == Yes) { .did -e $dname 12,13 | .did -c $dname 11 | .did -a $dname 12 %NickHighlight_soundfile }
    else { .did -c $dname 10 }
  }
  if (%NickHighlight_ontop == Yes) { .did -c $dname 7 }
  if (%NickHighlight_hidden == Yes) { .did -c $dname 22 | .did -b $dname 7 }
  var %a = 1
  while (%a <= $ini($shortfn($scriptdirNH\NickHighlight2.ini),0)) {
    .did -a $dname 16 $ini($shortfn($scriptdirNH\NickHighlight2.ini),%a)
    inc %a
  }
  var %a = 1
  while (%a <= $ini($shortfn($scriptdirNH\NH_Ignore.ini),0)) {
    .did -a $dname 25 $ini($shortfn($scriptdirNH\NH_Ignore.ini),%a)
    inc %a
  }
  if (%nickHighlight_mode == on) {
    .did -c $dname 19
    .did -e $dname 2,3,4,5
  }

}
on *:DIALOG:NickHighlight:init:0: {
  .dll $shortfn($scriptdirDLL\mdx.dll) SetMircVersion $version
  .dll $shortfn($scriptdirDLL\mdx.dll) MarkDialog $dname
  .dll $shortfn($scriptdirDLL\mdx.dll) SetControlMDX $dname 2 ListView report single grid > $shortfn($scriptdirDLL\Views.mdx)
  .did -i $dname 2 1 headerdims 30 75 50 75 180
  .did -i $dname 2 1 headertext $chr(35) $chr(9) Nickname $chr(9) Time $chr(9) Channel $chr(9) Message
}
on *:DIALOG:NickHighlight:sclick:1: {
  .dialog -mdo NickHighlight_options NickHighlight_options
}
on *:ACTION:*:*: {
  if (%NickHighlight_mode == on) {
    if ($ignoreNickHighlight($nick,$chan) == yes) { halt }
    var %a = 1
    while (%a <= $ini($shortfn($scriptdirNH\NickHighlight2.ini),0)) {
      if ($eval($ini($shortfn($scriptdirNH\NickHighlight2.ini), %a),2) isin $1-) {
        if ($appstate isin %NickHighlight_AppState) {
          if (!$dialog(NickHighlight)) {
            if (%NickHighlight_ontop == yes) && (%NickHighlight_hidden != Yes) { .dialog -mdo NickHighlight NickHighlight }
            else { 
              if (%NickHighlight_hidden != Yes) {
                .dialog -md NickHighlight NickHighlight
              }
            }
          }
          .set %NHtemp $ini(NickHighlight.ini,0)
          .inc %NHtemp 1e
          .writeini -n NickHighlight.ini %NHtemp Nick $nick
          .writeini -n NickHighlight.ini %NHtemp Msg ACTION: $1-
          .writeini -n NickHighlight.ini %NHtemp *!user@host $iif(!$address($nick,0),Unknown,$address($nick,0))
          .writeini -n NickHighlight.ini %NHtemp *!*user@host $iif(!$address($nick,1),Unknown,$address($nick,1))
          .writeini -n NickHighlight.ini %NHtemp *!*@host $iif(!$address($nick,2),Unknown,$address($nick,2))
          .writeini -n NickHighlight.ini %NHtemp *!*user@*.host $iif(!$address($nick,3),Unknown,$address($nick,3))
          .writeini -n NickHighlight.ini %NHtemp *!*@*.host $iif(!$address($nick,4),Unknown,$address($nick,4))
          .writeini -n NickHighlight.ini %NHtemp nick!user@host $iif(!$address($nick,5),Unknown,$address($nick,5))
          .writeini -n NickHighlight.ini %NHtemp nick!*user@host $iif(!$address($nick,6),Unknown,$address($nick,6))
          .writeini -n NickHighlight.ini %NHtemp nick!*@host $iif(!$address($nick,7),Unknown,$address($nick,7))
          .writeini -n NickHighlight.ini %NHtemp nick!*user@*.host $iif(!$address($nick,8),Unknown,$address($nick,8))
          .writeini -n NickHighlight.ini %NHtemp nick!*@*.host $iif(!$address($nick,9),Unknown,$address($nick,9))
          .writeini -n NickHighlight.ini %NHtemp Time $time
          .writeini -n NickHighlight.ini %NHtemp Server $server
          .writeini -n NickHighlight.ini %NHtemp Network $network
          .writeini -n NickHighlight.ini %NHtemp Channel $iif(!$chan,$iif(!$nick,UNKNOWN,$nick),$chan)
          if (%NickHighlight_hidden != Yes) { .did -a NickHighlight 2 $ini(NickHighlight.ini,0) $chr(9)  $nick $chr(9) $time $chr(9) $chan $chr(9) ACTION: $1- }
        }
        if (%NickHighlight_sound == On) {
          if ($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scritpdirNH\NickHighlight2.ini), %a), Sound) == Beep) { .beep 3 2 }
          else { 
            if ($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scritpdirNH\NickHighlight2.ini), %a), Sound) == None) { halt }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .mp3) { .set %NickHighlight_stype -p }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .wav) { .set %NickHighlight_stype -w }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .mid) { .set %NickHighlight_stype -m }
            .splay %Nickighlight_stype $shortfn($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound))
          }
        }
        break
      }
      inc %a
    }
  }
}
on *:NOTICE:*:?: {
  if (%NickHighlight_mode == on) {
    if ($ignoreNickHighlight($nick,NOTICE) == yes) { halt }
    var %a = 1
    while (%a <= $ini($shortfn($scriptdirNH\NickHighlight2.ini),0)) {
      if ($eval($ini($shortfn($scriptdirNH\NickHighlight2.ini), %a),2) isin $1-) {
        if ($appstate isin %NickHighlight_AppState) {
          if (!$dialog(NickHighlight)) {
            if (%NickHighlight_ontop == yes) && (%NickHighlight_hidden != Yes) { .dialog -mdo NickHighlight NickHighlight }
            else {
              if (%NickHighlight_hidden != Yes) { 
                .dialog -md NickHighlight NickHighlight
              }
            }
          }
          .set %NHtemp $ini(NickHighlight.ini,0)
          .inc %NHtemp 1e
          .writeini -n NickHighlight.ini %NHtemp Nick $nick
          .writeini -n NickHighlight.ini %NHtemp Msg NOTICE: $1-
          .writeini -n NickHighlight.ini %NHtemp *!user@host $iif(!$address($nick,0),Unknown,$address($nick,0))
          .writeini -n NickHighlight.ini %NHtemp *!*user@host $iif(!$address($nick,1),Unknown,$address($nick,1))
          .writeini -n NickHighlight.ini %NHtemp *!*@host $iif(!$address($nick,2),Unknown,$address($nick,2))
          .writeini -n NickHighlight.ini %NHtemp *!*user@*.host $iif(!$address($nick,3),Unknown,$address($nick,3))
          .writeini -n NickHighlight.ini %NHtemp *!*@*.host $iif(!$address($nick,4),Unknown,$address($nick,4))
          .writeini -n NickHighlight.ini %NHtemp nick!user@host $iif(!$address($nick,5),Unknown,$address($nick,5))
          .writeini -n NickHighlight.ini %NHtemp nick!*user@host $iif(!$address($nick,6),Unknown,$address($nick,6))
          .writeini -n NickHighlight.ini %NHtemp nick!*@host $iif(!$address($nick,7),Unknown,$address($nick,7))
          .writeini -n NickHighlight.ini %NHtemp nick!*user@*.host $iif(!$address($nick,8),Unknown,$address($nick,8))
          .writeini -n NickHighlight.ini %NHtemp nick!*@*.host $iif(!$address($nick,9),Unknown,$address($nick,9))
          .writeini -n NickHighlight.ini %NHtemp Time $time
          .writeini -n NickHighlight.ini %NHtemp Server $server
          .writeini -n NickHighlight.ini %NHtemp Network $network
          .writeini -n NickHighlight.ini %NHtemp Channel NOTICE
          if (%NickHighlight_hidden != Yes) { .did -a NickHighlight 2 $ini(NickHighlight.ini,0) $chr(9)  $nick $chr(9) $time $chr(9) NOTICE $chr(9) $1- }
        }
        if (%NickHighlight_sound == On) {
          if ($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scritpdirNH\NickHighlight2.ini), %a), Sound) == Beep) { .beep 3 2 }
          else { 
            if ($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scritpdirNH\NickHighlight2.ini), %a), Sound) == None) { halt }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .mp3) { .set %NickHighlight_stype -p }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .wav) { .set %NickHighlight_stype -w }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .mid) { .set %NickHighlight_stype -m }
            .splay %Nickighlight_stype $shortfn($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound))
          }
        }
        break
      }
      inc %a
    }
  }
}
on *:TEXT:*:#: {
  if (%NickHighlight_mode == on) {
    if ($ignoreNickHighlight($nick,$chan) == yes) { halt }
    var %a = 1
    while (%a <= $ini($shortfn($scriptdirNH\NickHighlight2.ini),0)) {
      if ($eval($ini($shortfn($scriptdirNH\NickHighlight2.ini), %a),2) isin $1-) {
        if ($appstate isin %NickHighlight_AppState) {
          if (!$dialog(NickHighlight)) {
            if (%NickHighlight_ontop == yes) && (%NickHighlight_hidden != Yes) { .dialog -mdo NickHighlight NickHighlight }
            else { 
              if (%NickHighlight_hidden != Yes) {
                .dialog -md NickHighlight NickHighlight 
              }
            }
          }
          .set %NHtemp $ini(NickHighlight.ini,0)
          .inc %NHtemp 1
          .writeini -n NickHighlight.ini %NHtemp Nick $nick
          .writeini -n NickHighlight.ini %NHtemp Msg $1-
          .writeini -n NickHighlight.ini %NHtemp *!user@host $iif(!$address($nick,0),Unknown,$address($nick,0))
          .writeini -n NickHighlight.ini %NHtemp *!*user@host $iif(!$address($nick,1),Unknown,$address($nick,1))
          .writeini -n NickHighlight.ini %NHtemp *!*@host $iif(!$address($nick,2),Unknown,$address($nick,2))
          .writeini -n NickHighlight.ini %NHtemp *!*user@*.host $iif(!$address($nick,3),Unknown,$address($nick,3))
          .writeini -n NickHighlight.ini %NHtemp *!*@*.host $iif(!$address($nick,4),Unknown,$address($nick,4))
          .writeini -n NickHighlight.ini %NHtemp nick!user@host $iif(!$address($nick,5),Unknown,$address($nick,5))
          .writeini -n NickHighlight.ini %NHtemp nick!*user@host $iif(!$address($nick,6),Unknown,$address($nick,6))
          .writeini -n NickHighlight.ini %NHtemp nick!*@host $iif(!$address($nick,7),Unknown,$address($nick,7))
          .writeini -n NickHighlight.ini %NHtemp nick!*user@*.host $iif(!$address($nick,8),Unknown,$address($nick,8))
          .writeini -n NickHighlight.ini %NHtemp nick!*@*.host $iif(!$address($nick,9),Unknown,$address($nick,9))
          .writeini -n NickHighlight.ini %NHtemp Time $time
          .writeini -n NickHighlight.ini %NHtemp Server $server
          .writeini -n NickHighlight.ini %NHtemp Network $network
          .writeini -n NickHighlight.ini %NHtemp Channel $chan
          if (%NickHighlight_hidden != Yes) { .did -a NickHighlight 2 $ini(NickHighlight.ini,0) $chr(9) $nick $chr(9) $time $chr(9) $chan $chr(9) $1- }
        }
        if (%NickHighlight_sound == On) {
          if ($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scritpdirNH\NickHighlight2.ini), %a), Sound) == Beep) { .beep 3 2 }
          else { 
            if ($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scritpdirNH\NickHighlight2.ini), %a), Sound) == None) { halt }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .mp3) { .set %NickHighlight_stype -p }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .wav) { .set %NickHighlight_stype -w }
            if ($gettok($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound),2,46) == .mid) { .set %NickHighlight_stype -m }
            .splay %Nickighlight_stype $shortfn($readini($shortfn($scriptdirNH\NickHighlight2.ini), $ini($shortfn($scriptdirNH\NickHighlight2.ini), %a), Sound))
          }
        }
        break
      }
      inc %a
    }
  }
}
menu * {
  NickHighlight:/dialog -md NickHighlight NickHighlight
}
on *:LOAD: {
  echo -a NickHighlight by Marius successfully loaded, opening the Highlight options.
  .dialog -mdo NickHighlight_options NickHighlight_options
}
on *:UNLOAD: {
  echo -a NickHighlight variables are kept when unloading.
  echo -a If you wish to remove the variables, please use /unset %NickHigh* and it will remove them all
  echo -a Thank you for using NickHighlight by Marius
}
