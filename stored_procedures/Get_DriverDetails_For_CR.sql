-- Check if the procedure 'Get_DriverDetails_For_CR' exists before creating
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_DriverDetails_For_CR]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_DriverDetails_For_CR]    
AS    
BEGIN    
    
Select distinct     
VD.Vehicle_Name,   
CASE WHEN E.Employee_FName +'' ''+E.Employee_LName IS NULL THEN ''Not Assigned''     
     ELSE E.Employee_FName +'' ''+E.Employee_LName     
END as Employee,    
  
CASE WHEN D.License_Number  IS NULL THEN ''-''     
     ELSE D.License_Number    
END as License_Number,    
  
CASE WHEN D.CurrentAge  IS NULL THEN ''-''     
     ELSE D.CurrentAge      
END as CurrentAge,  
  
   
D.ReportingAuthority,    
CASE WHEN E.Employee_Mobile IS NULL THEN ''Not Provided''     
     ELSE E.Employee_Mobile                                           
     END AS Employee_Mobile,    
VD.Vehicle_Number,    
VD.Vehicle_registration,    
VD.Vehicle_seating_Capacity    
    
    
    
    
From dbo.Tbl_Vehicle_details VD    
left join Tbl_Vehicle_Route_Mapping VR on VR.Vehicle_Id=VD.Vehicle_Id    
left join  Tbl_RouteDetails RD on RD.Route_Id= VR.Route_Id    
left join  dbo.Tbl_Employee E on E.Employee_Id=VD.Vehicle_Driver_Id    
left join  dbo.Tbl_DriverDetails D on D.Employee_Id=E.Employee_Id    
    
Where VD.Vehicle_Del_Status=0    
END
    ')
END;
GO
