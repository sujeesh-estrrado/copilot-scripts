IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_FollowUp_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_FollowUp_Status]
        AS
        BEGIN
               select Followp_Id as Status_Id,Followup_Name as Status from Tbl_FollowupStatus_Master  where Followup_Name!='''' and Followup_DelStatus=0

        END
    ')
END
