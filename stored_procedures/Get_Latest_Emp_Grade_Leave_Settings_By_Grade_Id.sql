IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Latest_Emp_Grade_Leave_Settings_By_Grade_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Get_Latest_Emp_Grade_Leave_Settings_By_Grade_Id] 
(      
@Grade_Id bigint      
)      
      
as      
      
begin      
select S.*,L.Leave_Type_Name from Tbl_Leave_Settings S left join dbo.Tbl_Leave_Type L on L.Leave_Type_Id=S.Leave_Type_Id      
where  S.Leave_DateFrom IN       
(      
SELECT MAX(T.Leave_DateFrom) as Leave_DateFrom FROM Tbl_Leave_Settings T where T.Grade_Id=@Grade_Id      
)  and  S.Grade_Id=@Grade_Id   and Leave_Delete_Status =0  
      
end

   ')
END;
