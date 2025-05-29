IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Seat_CapacityNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_GetAll_Course_Seat_CapacityNew] (@facultyid bigint=0)    
          
AS          
          
BEGIN          
   if (@facultyid=0)    
   begin    
SELECT           
SC.totalCapacity_Id as ID,O.Organization_Name,        
SC.Batch_Id,        
SC.Category_Id,        
SC.Total_Capacity,        
SC.Department_Id,        
BD.Batch_Code as Batch,        
CC.Course_Category_Name as CategoryName,        
D.Department_Name as DepartmentName        
        
        
FROM Tbl_Course_Seat_TotalCapacity SC        
INNER JOIN Tbl_Course_Batch_Duration BD On SC.Batch_Id=BD.Batch_Id   and SC.Department_Id=BD.Duration_Id     
inner join Tbl_Program_Duration CD On BD.Duration_Id=CD.Duration_Id        
inner join [Tbl_Organzations ] O on O.Organization_Id=SC.Org_Id     
inner join dbo.Tbl_Course_Department Tbl_Course_Department on Tbl_Course_Department.Department_Id=CD.Program_Category_Id      
inner join  dbo.Tbl_Department D on D.Department_Id=Tbl_Course_Department.Department_Id             
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=Tbl_Course_Department.Course_Category_Id       
        
where   SC.Delete_status=0      
        
 end    
 else    
 begin    
     
 SELECT           
SC.totalCapacity_Id as ID,O.Organization_Name,        
SC.Batch_Id,        
SC.Category_Id,        
SC.Total_Capacity,        
SC.Department_Id,        
BD.Batch_Code as Batch,        
CC.Course_Category_Name as CategoryName,        
D.Department_Name as DepartmentName        
        
        
FROM Tbl_Course_Seat_TotalCapacity SC        
INNER JOIN Tbl_Course_Batch_Duration BD On SC.Batch_Id=BD.Batch_Id   and SC.Department_Id=BD.Duration_Id     
inner join Tbl_Program_Duration CD On BD.Duration_Id=CD.Duration_Id        
inner join [Tbl_Organzations ] O on O.Organization_Id=SC.Org_Id     
inner join dbo.Tbl_Course_Department Tbl_Course_Department on Tbl_Course_Department.Department_Id=CD.Program_Category_Id      
inner join  dbo.Tbl_Department D on D.Department_Id=Tbl_Course_Department.Department_Id            
inner join Tbl_Emp_CourseDepartment_Allocation EA on D.GraduationTypeId=EA.Allocated_CourseDepartment_Id    
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=Tbl_Course_Department.Course_Category_Id       
        
where   SC.Delete_status=0  and EA.Employee_Id=@facultyid    
 end            
END    
');
END;