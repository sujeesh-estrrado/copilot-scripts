IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetFineSettings_ForAuto]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetFineSettings_ForAuto]
as begin

select f.Fine_Amount,fm.Role_Id,f.Fine_Details_Id,
(select role_Name from dbo.tbl_Role where role_Id=fm.Role_Id) as Role

 from dbo.Tbl_LMS_Fine_Details f


inner join dbo.Tbl_LMS_Fine_Master fm on f.Fine_Master_Id=fm.Fine_Master_Id

where fm.Is_AutoIncrement=0
end
');
END;