IF NOT EXISTS (

    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_tbl_get_all_employee_hostel_fees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Get_All_Employee_Hostel_Fees]             
@Department_Id bigint,                  
@Month Datetime                     
AS                    
BEGIN                    
 Select              
 Distinct E.Employee_Id As Id,              
 Employee_FName+'' ''+Employee_LName As [Name],              
 Hostel_Name,                    
 hf.Amount,  
ISNULL(cast(hfd.Hostel_Fee_Payment_Id as varchar(100)),''0'') As Hostel_Fee_Payment_Id,   
 (hf.Amount-ISNULL(hfd.Amount,0)) As BalanceAmount,                    
 hf.HostelId,                
 Case When hfd.Amount is null Then 0 --not settled                    
      When hfd.Amount=hf.Amount Then 1 -- fully settled                    
      else 2 End As PaymentStatus -- partially settled                  
 From Tbl_Hstl_Student_Admission ha            
 Inner Join Tbl_Hostel_Fee hf on hf.HostelId=ha.Hostel_Id                    
 Inner Join  Tbl_Employee E On ha.Student_Id=E.Employee_Id  and ha.Status=1                  
 Inner Join Tbl_Employee_Official EO on E.Employee_Id=EO.Employee_Id                       
 Inner Join Tbl_HostelRegistration hr on hr.Hostel_Id=hf.HostelId                    
 Left Join Tbl_Hostel_Fee_Payment_Detail hfd on hfd.HostelFeeId=hf.HostelFeeId  and hfd.Delete_Status=0       
 and hfd.[Month]=@Month and E.Employee_Id=(Select StudentOrEmployee_Id From Tbl_Hostel_Fee_Payment Where Hostel_Fee_Payment_Id=hfd.Hostel_Fee_Payment_Id)             
 Where   (Date =   @Month)   and  Department_Id= @Department_Id  
and     ((Datepart(mm,@Month)) between (Datepart(mm,Admission_Date)) and ISNULL((Datepart(mm,Leaving_Date)),(Datepart(mm,getdate()))))
and     ((Datepart(yyyy,@Month)) between (Datepart(yyyy,Admission_Date)) and ISNULL((Datepart(yyyy,Leaving_Date)),(Datepart(yyyy,getdate()))))
   
 Order By [Name] ASC                              
                    
END
    ')
END;
