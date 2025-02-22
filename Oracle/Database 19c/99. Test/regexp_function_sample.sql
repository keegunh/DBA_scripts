/*
REGEXP_LIKE(source_string, pattern [, match_parameter])
	Similar to the LIKE operator, but performs regular expression matcihng instead of simple pattern matching
	match_parameter
		'i': case-insensitive matching
		'c': case-sensitive matching
		'n': allows the "." character to match the newline character instead of any character
		'm': treats the source_string value as multiple lines, where ^ is the start of a line and $ is the end of a line
		
	if you don't specify a match parameter, then:
		the default case sensitivity is determined by the parameter NLS_SORT
		the period character doesn't match the newline character
		the source string is treated as a single line and not multiple lines
	
REGEXP_INSTR(source_string, pattern [, position [, occurrence [, return_option [, match_parameter [, sub_expression ] ] ] ] ])
	Searches for a given string for a regular expression pattern and returns the position where the match is found

REGEX_REPLACE(source_string, pattern [, replace_string [, position [, occurrence [, match_parameter ] ] ] ])
	Searches for a regular expression pattern within a given string and returns the matched substring
	
REGEXP_COUNT(source_string, pattern [, position [, match_parameter ] ])

Syntax			Operator Name								Description
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
.				Any Character -- Dot						Matches any character
+				One or More -- Plus Quantifier				Matches one or more occurrences of the preceding subexpression
?				Zero or One -- Question Mark Quantifier		Matches zero or one occurrence of the preceding subexpression
*				Zero or More -- Star Quantifier				Matches zero or more occurrences of the preceding subexpression
{m}				Interval -- Exact Count						Matches exactly m occurrences of the preceding subexpression
{m,}			Interval -- At Least Count					Matches at least m occurrences of the preceding subexpression
{m,n}			Interval -- Between Count					Matches at least m, but not more than n occurrences of the preceding subexpression
[...]			Matching Character List						Matches any character in list ...
[^...]			Non-Matching Character List					Matches any charcater not in the list ...
|				Or											'a|b' matches character 'a' or 'b'
(...)			Subexpression or Grouping					Treat expression ... as a unit. The subexpression can be a string of literals or a complex expression containing operators.
\n				Backreference								Matches the nth preceding subexpression, where n is an integer from 1 to 9
\				Escape Character							Treat the subsequent metacharacter in the expression as a literal
^				Beginning of Line Anchor					Match the subsequent expression only when it occurs at the beginning of a line
$				End of Line Anchor							Match the preceding expression only when it occurs at the end of a line
[:class:]		POSIX Character Class						Match any character belonging to the specified character 'class'. Can be used inside any list expression
[.element.]		POSIX Collating Sequence					Specifies a collating sequence to use in the regular expression. The 'element' you use must be a defined collating sequence, in the current locale.
[*character*]	POSIX Character Equivalence Class			Match characters having the same base character as the 'character' you specify
*/


WITH EXPRESSION_LIST AS (
    SELECT 'abc' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'adc' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'a1c' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'a&c' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abb' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'a' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'aa' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'aaa' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'bbb' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'ac' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'adc' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abbc' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abbbbc' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'aaaaa' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'aaaa' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'aaa' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'at' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'bet' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'cot' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abcdef' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'ghi' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'hijk' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'lmn' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abcdefghi' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'defghi' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'defdef' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abc+def' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'abcDEFghi' AS EXPRESSION FROM DUAL
     UNION ALL
    SELECT 'chabc' AS EXPRESSION FROM DUAL
)
SELECT EXPRESSION
     , REGEXP_SUBSTR(EXPRESSION, '^def') AS MATCHED_SUBSTR
     , REGEXP_INSTR(EXPRESSION, '^def') AS MATCHED_POSITION
     , REGEXP_REPLACE(EXPRESSION, '^def', 'DEF') AS MATCH_REPLACE
     , REGEXP_COUNT(EXPRESSION, '^def') AS MATCH_COUNT
  FROM EXPRESSION_LIST
 WHERE 1=1
   AND REGEXP_LIKE(EXPRESSION, '^def', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'a.c', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'a+', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'ab*c', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'a{5}', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'a{3,}', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'a{3,5}', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'abc', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, '[^abc]', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, '(abc|def)\1', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, '\+', 'm')
   -- AND REGEXP_LIKE(EXPRESSION, 'def$', 'm')  
;