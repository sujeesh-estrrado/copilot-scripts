IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Update_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                   
CREATE procedure [dbo].[SP_Tbl_Employee_Update_By_Employee_Id]                
( @Employee_FName varchar(50),                
           @Employee_LName varchar(50),                
           @Employee_DOB datetime,                
           @Employee_Gender varchar(50),                
           @Employee_Permanent_Address varchar(250),                
           @Employee_Present_Address varchar(250),                
           @Employee_Phone varchar(50),                
           @Employee_Mail varchar(50),                
           @Employee_Mobile varchar(50),                
           @Employee_Martial_Status varchar(20),                
           @Blood_Group varchar(20),                
           @Employee_Id_Card_No varchar(20),                
           @Employee_Nationality varchar(50),             
           @Employee_State varchar(50),              
           @Employee_Experience_If_Any varchar(500),                
           @Employee_Father_Name varchar(50),                
           @Employee_Nominee_Name varchar(50),                
           @Employee_Nominee_Relation varchar(50),                
           @Employee_Nominee_Phone varchar(50),                
           @Employee_Nominee_Address varchar(500),               
     @Employee_Type varchar(50),              
     @Employee_Id bigint,        
     @Employee_Aadhar varchar(50),        
     @Identification_No varchar(50) ,  
      @Employee_City varchar(max),  
     @Employee_postcode  varchar(50),  
       
@Spouse_Name varchar(MAX),  
@Spouse_LName VARCHAR(MAX),   
@Spouse_IC_No varchar(MAX),   
@NoofChildren varchar(MAX),   
@Spouse_Email varchar(MAX),   
@Spouse_MobileNo varchar(15),
@Emergency_Name varchar(200), 
@Emergency_Number  varchar(15)  ,
@Employee_Country varchar(MAX)                             
)                
as                
             
begin                
                
                
                
Update Tbl_Employee set                
                 
                           
   Employee_FName=@Employee_FName                
           ,Employee_LName=@Employee_LName                
           ,Employee_DOB= @Employee_DOB                
           ,[Employee_Gender]=@Employee_Gender,                
           [Employee_Permanent_Address]=@Employee_Permanent_Address,                
           [Employee_Present_Address]=@Employee_Present_Address,                
           [Employee_Phone]=@Employee_Phone,                
           [Employee_Mail]=@Employee_Mail,                
           [Employee_Mobile]=@Employee_Mobile,                
           [Employee_Martial_Status]=@Employee_Martial_Status,                
           [Blood_Group]=@Blood_Group,                
           [Employee_Id_Card_No]=@Employee_Id_Card_No,                
           [Employee_Nationality]=@Employee_Nationality,            
Employee_State=@Employee_State,              
           [Employee_Experience_If_Any]=@Employee_Experience_If_Any,                
           [Employee_Father_Name]=@Employee_Father_Name,                
           [Employee_Nominee_Name]=@Employee_Nominee_Name,                
           [Employee_Nominee_Relation]=@Employee_Nominee_Relation,                
           [Employee_Nominee_Phone]=@Employee_Nominee_Phone,                
           [Employee_Nominee_Address]=@Employee_Nominee_Address,                
           [Employee_Type] =@Employee_Type  ,            
           Employee_Aadhar=@Employee_Aadhar,        
     Identification_No =@Identification_No,  
     Employee_City=@Employee_City,  
     Employee_postcode=@Employee_postcode,  
     Spouse_FName=@Spouse_Name,  
Spouse_LName=@Spouse_LName,   
Spouse_IC_No=@Spouse_IC_No,   
NoofChildren=@NoofChildren,   
Spouse_Email=@Spouse_Email,   
Spouse_MobileNo=@Spouse_MobileNo,
Emergency_Name=@Emergency_Name,
Employee_Country=@Employee_Country,
Emergency_Number=@Emergency_Number
                 
          where Employee_Id=@Employee_Id                
                
                
END 
    ')
END
