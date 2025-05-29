IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_CourseBatchDuration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Insert_CourseBatchDuration]
(@Org_Id bigint,
@IntakeMasterID  bigint,
@Duration_Id bigint,
@Batch_Code varchar(100),          
@Batch_From datetime,
@Batch_To datetime,
@Batch_DelStatus bit =0,
@StudyMode varchar(50),
@EntryDate datetime,
@Syllubuscode varchar(50),
@CloseDate datetime,
@Regdate date,
@created_by bigint =0,@CloseDateinter	datetime ='''',
@OpenDateinter datetime ='''',
@intakeNo varchar(20)='''')        
AS          
      
IF  EXISTS (SELECT Duration_Id FROM Tbl_Course_Batch_Duration WHERE Duration_Id=@Duration_Id and Batch_DelStatus=0 and IntakeMasterID =@IntakeMasterID)          
BEGIN          
  RAISERROR (''Data Already exists.'', -- Message text.          
               16, -- Severity.          
               1 -- State.          
               );          
END          
ELSE            
          
BEGIN          
INSERT INTO dbo.Tbl_Course_Batch_Duration(Org_Id,IntakeMasterID,Duration_Id,Batch_Code,Batch_From,Batch_To,Batch_DelStatus,Study_Mode,Intro_Date,SyllubusCode,Close_Date,created_by,dateregsatart,lastnumber,intake_no)          
VALUES(@Org_Id,@IntakeMasterID,@Duration_Id,@Batch_Code,@Batch_From,@Batch_To,@Batch_DelStatus,@StudyMode,@EntryDate,@Syllubuscode,@CloseDate,@created_by,@Regdate,0,@intakeNo)          
          
          
END
    ')
END
