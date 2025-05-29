IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Team]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Team]
(
     @TeamLead  bigint,
	 @TeamName   varchar(max)
	
	
)
As

Begin


Insert into Tbl_Teams(Team_Lead, Team_Name)values(@TeamLead,@TeamName)
Select SCOPE_IDENTITY()

	
End
    ');
END;
