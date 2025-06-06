-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Employee_Taken_Leaves]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
           
CREATE procedure [dbo].[Get_Employee_Taken_Leaves]  --27,1       
(                
@Employee_Id bigint,                
@Leave_Type_Id bigint                
)                                                                     
as                
begin                
                
Select L.Emp_Leave_Id,L.Employee_Id,L.Emp_Leave_Type,L.Emp_Leave_FromDate,L.Emp_Leave_ToDate,    
L.Emp_Leave_Reason,L.Emp_Leave_Approve_Status,L.Emp_Leave_Delete_Status        
,case when L.Emp_Leave_IsHalfDay =1 then ''Half Day'' else ''Full Day'' end as Emp_Leave_IsHalfDay        
,T.Leave_Type_Name,          
case when L.Emp_Leave_Approve_Status<>2 then (select            
 case when EL.Emp_Leave_IsHalfDay =0  then           
DATEDIFF(DAY,EL.Emp_Leave_FromDate, EL.Emp_Leave_ToDate)+1    
 when EL.Emp_Leave_IsHalfDay =1 then .5          
end as NumberofDays from dbo.Tbl_Emp_Leave_Apply EL where EL.Emp_Leave_Id=L.Emp_Leave_Id)           
when L.Emp_Leave_Approve_Status=2 then           
   0   end as NumberofDays          
 from dbo.Tbl_Emp_Leave_Apply L             
left join dbo.Tbl_Leave_Type T on T.Leave_Type_Id=L.Emp_Leave_Type         
inner join  dbo.Tbl_Employee_Official eo on eo.Employee_Id=L.Employee_Id                   
where L.Employee_Id=@Employee_Id                
 and L.Emp_Leave_FromDate >=(                
Select TOP 1 Leave_DateFrom as Emp_Leave_FromDate            
 from dbo.Tbl_Grade_Mapping INNER JOIN                        
dbo.Tbl_Leave_Settings ON dbo.Tbl_Grade_Mapping.Emp_Grade_Id = dbo.Tbl_Leave_Settings.Grade_Id            
WHERE     (dbo.Tbl_Grade_Mapping.Employee_Id = @Employee_Id)               
  ORDER BY Emp_Grade_Mapping_Id DESC                
                
)                 
and L.Emp_Leave_ToDate <=(                
Select TOP 1 Leave_DateTo as Emp_Leave_ToDate            
 from dbo.Tbl_Grade_Mapping INNER JOIN                        
dbo.Tbl_Leave_Settings ON dbo.Tbl_Grade_Mapping.Emp_Grade_Id = dbo.Tbl_Leave_Settings.Grade_Id            
WHERE     (dbo.Tbl_Grade_Mapping.Employee_Id = @Employee_Id)                
  ORDER BY Emp_Grade_Mapping_Id DESC                      
)                
and L.Emp_Leave_Type=@Leave_Type_Id and convert(datetime,eo.Employee_DOJ,103)<=L.Emp_Leave_FromDate           
                
end 
    ')
END;
GO
