IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[OVERALL_ACTIVITY_REPORT3]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[OVERALL_ACTIVITY_REPORT3]      
 AS BEGIN  
   
 truncate table tbl_FeeArrearList  
 DECLARE @COUPONPREV INT  
 SET    @COUPONPREV=  
  (select DISTINCT COUNT(FS.[Enquiry_Type]) AS NO_OF_COUPON_PREVIOUS--,FS.Candidate_Id,NA.Department_Id   
  from [Tbl_FollowUp_Status] FS        
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id      
  WHERE FS.[Enquiry_Type]=''COUPON''       
  AND  DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))      
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))       
  GROUP BY FS.[Enquiry_Type],FS.Candidate_Id,NA.Department_Id  
  )    
    
  --SELECT @COUPONPREV  
        
----------------CALLIN PREV  
  
DECLARE @CALLINPREV INT  
SET @CALLINPREV=  
  (select DISTINCT COUNT(FS.[Enquiry_Type]) AS NO_OF_CALLIN_PREVIOUS from [Tbl_FollowUp_Status] FS        
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id      
  WHERE FS.[Enquiry_Type]=''CALL IN''       
  AND  DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))      
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))       
  GROUP BY FS.[Enquiry_Type],FS.Candidate_Id,NA.Department_Id)  
   
-- SELECT @OURPREV  
  
  --===============WALKIN PREV     
    
DECLARE @WALKINPREV INT  
SET @WALKINPREV=  
  (select DISTINCT COUNT(FS.[Enquiry_Type]) AS NO_OF_WALKIN_PREVIOUS from [Tbl_FollowUp_Status] FS        
 -- INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  --INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id      
  WHERE FS.[Enquiry_Type]=''WALK IN''       
  AND  DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))      
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))       
  GROUP BY FS.[Enquiry_Type],FS.Candidate_Id)  
  --SELECT @WALKINPREV  
      
    --=====================OURPREV  
      
      
    DECLARE @OURPREV INT  
SET @OURPREV=  
  (select DISTINCT COUNT(FS.[Enquiry_Type]) AS NO_OF_WALKIN_PREVIOUS from [Tbl_FollowUp_Status] FS        
 -- INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  --INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id      
  WHERE FS.[Enquiry_Type]=''OUR''       
  AND  DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))      
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))       
  GROUP BY FS.[Enquiry_Type],FS.Candidate_Id)  
  --SELECT @OURPREV  
      
      
     
--=====================FOLLOWUPPREV  
 DECLARE @FOLLOWPREV INT  
 SET @FOLLOWPREV=  
  (select  COUNT (FS.Follow_Up_Detail_Id) as NO_OF_FOLLOWUP  from dbo.Tbl_FollowUp_Detail  FS      
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  WHERE DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))      
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))       
   GROUP BY NA.Department_Id,FS.[Candidate_Id])     
--SELECT  @FOLLOWPREV  
         
       
       
--==============NEWENROL   
  DECLARE @NEWENROL INT  
  SET   @NEWENROL=    
   
  (SELECT COUNT (CPD.Candidate_Id) as NO_OF_ENROL_CURRENT FROM   
   Tbl_Candidate_Personal_Det CPD   
   
  WHERE DATEPART(m, RegDate) = DATEPART(m, DATEADD(m, -1, getdate()))      
  AND DATEPART(yyyy, RegDate) = DATEPART(yyyy, DATEADD(m, -1, getdate())) )      
  
 --SELECT @NEWENROL  
  
--===========ourcurr  
  
    DECLARE @OURCURR INT  
SET @OURCURR=  
  (select DISTINCT COUNT(FS.[Enquiry_Type]) AS CURRENT_OUR from [Tbl_FollowUp_Status] FS        
 -- INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  --INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id      
  WHERE FS.[Enquiry_Type]=''OUR''  AND Followup_Date= MONTH(GETDATE()))     
    
  --SELECT @OURCURR  
    
  --===============CURRENROL  
    
    DECLARE @CURRENROL INT  
  SET   @CURRENROL=    
  (SELECT COUNT (CPD.Candidate_Id) as NO_OF_ENROL_CURRENT FROM   
   Tbl_Candidate_Personal_Det CPD   
   WHERE CPD.RegDate=MONTH(GETDATE()) )  
  --SELECT @CURRENROL  
     
  
   --=============CURRFOLLOW  
     
    DECLARE @FOLLOWCURR INT  
 SET @FOLLOWCURR=  
  (select  COUNT (FS.Follow_Up_Detail_Id) as NO_OF_FOLLOWUP  from dbo.Tbl_FollowUp_Detail  FS      
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]       
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id       
  WHERE Followup_Date=MONTH(GETDATE())  )     
    
--SELECT  @FOLLOWCURR  
  
insert into dbo.tbl_FeeArrearList(PREVCOUPON,PREVCALLIN,PREVWALKIN,PREVOUR,PREVFOLLOW,PREVNEWENROL,CURROUR,CURENROL,CURFOLLOW)  
values(@COUPONPREV,@CALLINPREV,@WALKINPREV,@OURPREV,@FOLLOWPREV,@NEWENROL,@OURCURR,@CURRENROL,@FOLLOWCURR)  
  
select * from tbl_FeeArrearList  
END
    ')
END;
