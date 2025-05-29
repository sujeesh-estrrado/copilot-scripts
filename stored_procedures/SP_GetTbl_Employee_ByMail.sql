IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetTbl_Employee_ByMail]') 
    AND type = N'P'
)
BEGIN
    EXEC('
               
CREATE procedure [dbo].[SP_GetTbl_Employee_ByMail]             
(@Mail  Varchar(50))
as              
              
begin              
              
SELECT         
Employee_Id,        
Employee_FName,        
Employee_LName,        
Employee_DOB,        
Employee_Gender,        
Employee_Permanent_Address,        
Employee_Present_Address,        
Employee_Phone,        
Employee_Mail,        
Employee_Mobile,        
Employee_Martial_Status,        
Blood_Group,        
Employee_Id_Card_No,        
Employee_Nationality,        
Employee_Experience_If_Any,        
Employee_Father_Name,        
Employee_Nominee_Name,        
Employee_Nominee_Relation,        
Employee_Nominee_Phone,        
Employee_Nominee_Address,        
Employee_Status,        
Employee_Type,        
Employee_Img  ,     
Employee_Aadhar,     
Employee_FName +'' ''+ Employee_LName as Employee_Name,      
Employee_DOB as DOB,Employee_Gender as Gender,          
Employee_Mobile as Mobile      
        
          
FROM [Tbl_Employee]   where Employee_Status=0 and Employee_Mail=@Mail           
         
              
end
    ');
END;
