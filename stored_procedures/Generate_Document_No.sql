IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Generate_Document_No]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Generate_Document_No]               
   @flag bigint=0             
AS                
Declare @maxEnqId Bigint                
Declare @Current_Code varchar(50)                
Declare @TempMax_Id varchar(100)               
declare @Current_Year varchar(100)              
declare @Document_no varchar(100)              
BEGIN                
              
set @Current_Year=year(Getdate())                    
--set @maxEnqId=(select Max(ID) from dbo.Tbl_ManPower_Details)                
--set @maxEnqId=1             
if(@flag=0)          
begin          
 set @maxEnqId=(select Count(Manpower_Id) from Tbl_ManPower_Details where year(Created_Date)=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''MPP/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''MPP/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from Tbl_ManPower_Details where Document_No=@Current_Code)                
 begin                
      while(exists(select ''True'' from Tbl_ManPower_Details where Document_No=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''MPP/''+@Current_Year+''/''+@TempMax_Id                
                  
  end                
 end             
 end          
 else if(@flag=1)          
 BEGIN          
  set @maxEnqId=(select Count([ID]) from [dbo].[Tbl_Manpower_Request_Details] where year([Create_date])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''MPR/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''MPR/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [Tbl_Manpower_Request_Details] where Document_No=@Current_Code)                
 begin                
      while(exists(select ''True'' from [Tbl_Manpower_Request_Details] where Document_No=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''MPR/''+@Current_Year+''/''+@TempMax_Id                
             
                  
  end                
 end           
 END          
  else if(@flag=2)          
 BEGIN          
  set @maxEnqId=(select Count([Job_Id]) from [dbo].[Tbl_JobApplication_Deatils] where year([Application_Date])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''APL/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''APL/''+@Current_Year+''/''+@TempMax_Id                
 end                   if exists(select ''True'' from [dbo].[Tbl_JobApplication_Deatils] where [Application_No]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_JobApplication_Deatils] where [Application_No]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''APL/''+@Current_Year+''/''+@TempMax_Id                
               
                  
  end                
 end           
 END             
         
 --Job application Primary interview scheduled ID [START]        
 ELSE IF(@flag=3)        
  BEGIN          
  set @maxEnqId=(select Count([ID]) from [dbo].[Tbl_HRMS_Interview_Schedule] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''SI/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''SI/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Schedule] where [Schedule_Number]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Schedule] where [Schedule_Number]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''SI/''+@Current_Year+''/''+@TempMax_Id                
           
                  
  end                
 end           
 END          
 --Job application Primary interview scheduled ID [END]        
      
      
 --Interview Evaluation ID [START]        
 ELSE IF(@flag=4)        
  BEGIN          
  set @maxEnqId=(select Count([ID]) from [dbo].[Tbl_HRMS_Interview_Evaluation] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''EI/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''EI/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Evaluation] where EvaluationID=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Evaluation] where EvaluationID=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''EI/''+@Current_Year+''/''+@TempMax_Id                
             
  end                
 end           
 END          
 --Interview Evaluation ID [END]   
 else if(@flag=5)          
 BEGIN          
  set @maxEnqId=(select Count([JobOfferPreparationId]) from [dbo].[Tbl_JobOfferPreparation] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''JO/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''JO/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_JobOfferPreparation] where [Document_Number]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_JobOfferPreparation] where [Document_Number]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''JO/''+@Current_Year+''/''+@TempMax_Id                

  end                
 end           
 END  
  --Staff Personal Particular ID [START]        
 ELSE IF(@flag=6)        
  BEGIN          
  set @maxEnqId=(select Count([StaffPersonal_Id]) from [dbo].[Tbl_StaffPersonalParticular] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''SPP/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''SPP/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_StaffPersonalParticular] where [StaffPersonal_No]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_StaffPersonalParticular] where [StaffPersonal_No]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''SPP/''+@Current_Year+''/''+@TempMax_Id                
  
  end                
 end           
 END          
 --Interview Evaluation ID [END]           
select @Current_Code as Document_No                
END    ')
END
ELSE
BEGIN
EXEC('
           
ALTER procedure [dbo].[Generate_Document_No]               
   @flag bigint=0             
AS                
Declare @maxEnqId Bigint                
Declare @Current_Code varchar(50)                
Declare @TempMax_Id varchar(100)               
declare @Current_Year varchar(100)              
declare @Document_no varchar(100)              
BEGIN                
              
set @Current_Year=year(Getdate())                    
--set @maxEnqId=(select Max(ID) from dbo.Tbl_ManPower_Details)                
--set @maxEnqId=1             
if(@flag=0)          
begin          
 set @maxEnqId=(select Count(Manpower_Id) from Tbl_ManPower_Details where year(Created_Date)=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''MPP/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''MPP/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from Tbl_ManPower_Details where Document_No=@Current_Code)                
 begin                
      while(exists(select ''True'' from Tbl_ManPower_Details where Document_No=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''MPP/''+@Current_Year+''/''+@TempMax_Id                
                  
  end                
 end             
 end          
 else if(@flag=1)          
 BEGIN          
  set @maxEnqId=(select Count([ID]) from [dbo].[Tbl_Manpower_Request_Details] where year([Create_date])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''MPR/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''MPR/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [Tbl_Manpower_Request_Details] where Document_No=@Current_Code)                
 begin                
      while(exists(select ''True'' from [Tbl_Manpower_Request_Details] where Document_No=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''MPR/''+@Current_Year+''/''+@TempMax_Id                
             
                  
  end                
 end           
 END          
  else if(@flag=2)          
 BEGIN          
  set @maxEnqId=(select Count([Job_Id]) from [dbo].[Tbl_JobApplication_Deatils] where year([Application_Date])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''APL/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''APL/''+@Current_Year+''/''+@TempMax_Id                
 end                   if exists(select ''True'' from [dbo].[Tbl_JobApplication_Deatils] where [Application_No]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_JobApplication_Deatils] where [Application_No]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''APL/''+@Current_Year+''/''+@TempMax_Id                
               
                  
  end                
 end           
 END             
         
 --Job application Primary interview scheduled ID [START]        
 ELSE IF(@flag=3)        
  BEGIN          
  set @maxEnqId=(select Count([ID]) from [dbo].[Tbl_HRMS_Interview_Schedule] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''SI/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''SI/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Schedule] where [Schedule_Number]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Schedule] where [Schedule_Number]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''SI/''+@Current_Year+''/''+@TempMax_Id                
           
                  
  end                
 end           
 END          
 --Job application Primary interview scheduled ID [END]        
      
      
 --Interview Evaluation ID [START]        
 ELSE IF(@flag=4)        
  BEGIN          
  set @maxEnqId=(select Count([ID]) from [dbo].[Tbl_HRMS_Interview_Evaluation] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''EI/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''EI/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Evaluation] where EvaluationID=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_HRMS_Interview_Evaluation] where EvaluationID=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''EI/''+@Current_Year+''/''+@TempMax_Id                
             
  end                
 end           
 END          
 --Interview Evaluation ID [END]   
 else if(@flag=5)          
 BEGIN          
  set @maxEnqId=(select Count([JobOfferPreparationId]) from [dbo].[Tbl_JobOfferPreparation] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''JO/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''JO/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_JobOfferPreparation] where [Document_Number]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_JobOfferPreparation] where [Document_Number]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''JO/''+@Current_Year+''/''+@TempMax_Id                

  end                
 end           
 END  
  --Staff Personal Particular ID [START]        
 ELSE IF(@flag=6)        
  BEGIN          
  set @maxEnqId=(select Count([StaffPersonal_Id]) from [dbo].[Tbl_StaffPersonalParticular] where year([CreatedDate])=@Current_Year)          
 if(@maxEnqId is NULL or @maxEnqId = 0)                
  begin                
   set @Current_Code=''SPP/''+@Current_Year+''/1''                
  End                
 else                
  begin                
   set @maxEnqId=@maxEnqId+1                
   set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                
   set @Current_Code=''SPP/''+@Current_Year+''/''+@TempMax_Id                
 end                
   if exists(select ''True'' from [dbo].[Tbl_StaffPersonalParticular] where [StaffPersonal_No]=@Current_Code)                
 begin                
      while(exists(select ''True'' from [dbo].[Tbl_StaffPersonalParticular] where [StaffPersonal_No]=@Current_Code))                
  begin                 
  set @maxEnqId=@maxEnqId+1                  
  set @TempMax_Id=convert(varchar(100),@maxEnqId,103)                  
  set @Current_Code=''SPP/''+@Current_Year+''/''+@TempMax_Id                
  
  end                
 end           
 END          
 --Interview Evaluation ID [END]           
select @Current_Code as Document_No                
END


')
END
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Generate_Revision_No]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Generate_Revision_No]
            @Manpower_Id BIGINT
        AS
        BEGIN
            SELECT Revision_No FROM Tbl_ManPower_Details WHERE Manpower_ID = @Manpower_Id
        END
    ')
END

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Gert_ExamDetails_ByBatch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Gert_ExamDetails_ByBatch]
            @Duration_Mapping_Id BIGINT
        AS
        BEGIN
            SELECT DISTINCT Exam_Term AS ExamCode, Exam_Term AS Id
            FROM Tbl_Exam_Code_Master A
            INNER JOIN Tbl_Department_Subjects D ON D.Subject_Id = A.Subject_Id
            INNER JOIN Tbl_Semester_Subjects SD ON SD.Department_SubjectS_Id = D.Department_Subject_Id
            WHERE SD.Duration_Mapping_Id = @Duration_Mapping_Id
        END
    ')
END
