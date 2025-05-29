IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_FaciltyDepartment_Mapping_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_FaciltyDepartment_Mapping_ById]  @Facility_Deapartment_Id bigint   
As            
Begin    
  
select FDM.Facility_Deapartment_Id,ED.Dept_Name ,ED.Dept_Id , C.Campus_Id ,R.Room_Id,Tbl_Floor.Floor_Id, R.Room_Name+'' - ''+Tbl_Floor.Floor_Name+'' - ''+Tbl_Block.Block_Name as Room_Name , C.Campus_Name from tbl_Facility_Department_Mapping FDM  
inner join Tbl_Campus C on C.Campus_Id = FDM.Campus_Id  
inner join Tbl_Room R on R.Room_Id = FDM.Room_Id  
inner join Tbl_Floor ON R.Floor_Id = Tbl_Floor.Floor_Id   
INNER JOIN Tbl_Block ON R.Block_Id = Tbl_Block.Block_Id   
INNER JOIN Tbl_Campus ON R.Campus_Id = Tbl_Campus.Campus_Id     
inner join Tbl_Emp_Department ED on ED.Dept_Id = FDM.Department_Id  
where C.Campus_DelStatus = 0 and Dept_Status = 0 and FDM.Facility_Deapartment_Id = @Facility_Deapartment_Id  
  
END  
');
END;