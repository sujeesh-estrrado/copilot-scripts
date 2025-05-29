IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Split]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[Split](@sText varchar(8000), @sDelim varchar(20) = ''
'')
RETURNS @retArray TABLE (idx smallint Primary Key, value varchar(8000))
AS
BEGIN
DECLARE @idx int,
@value varchar(8000),
@bcontinue bit,
@iStrike int,
@iDelimlength int

IF @sDelim = ''Space''
BEGIN
SET @sDelim = '' ''
END

SET @idx = 0
SET @sText = LTrim(RTrim(@sText))
SET @iDelimlength = DATALENGTH(@sDelim)
SET @bcontinue = 1

if(Len(@sText) = 0)
return

IF NOT ((@iDelimlength = 0) or (@sDelim = ''Empty''))
BEGIN
WHILE @bcontinue = 1
BEGIN

--If you can find the delimiter in the text, retrieve the first element and
--insert it with its index into the return table.

IF CHARINDEX(@sDelim, @sText)>0
BEGIN
SET @value = SUBSTRING(@sText,1, CHARINDEX(@sDelim,@sText)-1)
BEGIN
INSERT @retArray (idx, value)
VALUES (@idx, @value)
END

--Trim the element and its delimiter from the front of the string.
--Increment the index and loop.
SET @iStrike = DATALENGTH(@value) + @iDelimlength
SET @idx = @idx + 1
SET @sText = LTrim(Right(@sText,DATALENGTH(@sText) - @iStrike))

END
ELSE
BEGIN
--If you can''''t find the delimiter in the text, @sText is the last value in
--@retArray.
SET @value = @sText
BEGIN
INSERT @retArray (idx, value)
VALUES (@idx, @value)
END
--Exit the WHILE loop.
SET @bcontinue = 0
END
END
END
ELSE
BEGIN
WHILE @bcontinue=1
BEGIN
--If the delimiter is an empty string, check for remaining text
--instead of a delimiter. Insert the first character into the
--retArray table. Trim the character from the front of the string.
--Increment the index and loop.
IF DATALENGTH(@sText)>1
BEGIN
SET @value = SUBSTRING(@sText,1,1)
BEGIN
INSERT @retArray (idx, value)
VALUES (@idx, @value)
END
SET @idx = @idx+1
SET @sText = SUBSTRING(@sText,2,DATALENGTH(@sText)-1)

END
ELSE
BEGIN
--One character remains.
--Insert the character, and exit the WHILE loop.
INSERT @retArray (idx, value)
VALUES (@idx, @sText)
SET @bcontinue = 0
END
END

END

RETURN
END

    ')
END
