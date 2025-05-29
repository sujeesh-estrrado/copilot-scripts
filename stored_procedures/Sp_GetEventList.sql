IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventList]
@flag bigint,
@createddatefrom nvarchar(50)=null,
@createddateto nvarchar(50)=null

as
begin
if(@flag=1)
begin
select Event_Title,Event_Id,
CONVERT(VARCHAR, CreatedDate, 103) AS CreatedDate,
CONVERT(VARCHAR, LastSubmissionDate, 103) AS LastSubmissionDate,
NumberOfSubmission from Tbl_EventList where DelStatus=0  
--AND ((convert(date,CreatedDate) = @createddatefrom) or (@createddatefrom is null) or (@createddatefrom ='''') )

--AND ((convert(date,CreatedDate) = @createddateto) or (@createddateto is null) or (@createddateto ='''') )
AND (
                @createddatefrom IS NULL OR @createddatefrom = '''' 
                OR CONVERT(DATE, CreatedDate) >= CONVERT(DATE, @createddatefrom)
            )
            AND (
                @createddateto IS NULL OR @createddateto = '''' 
                OR CONVERT(DATE, CreatedDate) <= CONVERT(DATE, @createddateto)
            )


end
end
    ')
END;
