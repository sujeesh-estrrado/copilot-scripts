IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_CounselorType_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_CounselorType_ByID]  --30108
(@Employee_Id bigint,
@Counselor_Type varchar(MAX)
)  
AS  
BEGIN  
Update Tbl_Employee set Counselor_Type=@Counselor_Type where Employee_Id=@Employee_Id
  
END
    ')
END
