SELECT name
     , statement
     , is_holdable
     , is_binary
     , is_scrollable
     , creation_time
  FROM pg_cursors ORDER BY name;