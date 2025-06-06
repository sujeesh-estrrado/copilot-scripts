IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_ManagerSponser]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Student_ManagerSponser]                 
 -- [dbo].[sp_Student_ManagerSponser] 3,1                
 @flag int= 0,                
 @studentsponsorid bigint=0,                
 @studentid bigint=0,                
 @sponsorid bigint=0,                
 @referenceno varchar(150)='''',               
 @amount decimal(18, 2)=0,                
 @durationstart date='''',                
 @durationend date='''',                
 @sponsorstatus bigint=0,                
 @createdby bigint=0,                
 @Batch bigint=0,                
 @SemID bigint=0                
                
AS                
BEGIN                
                
 if(@flag=1)---Insert Student_ManagerSponser---                
 begin                
  Insert into student_sponsor (studentid,sponsorid,referenceno,amount                
  ,durationstart,durationend,sponsorstatus,createdby,datecreated)                
  values(@studentid,@sponsorid,@referenceno,@amount,@durationstart,                
  @durationend,@sponsorstatus,@createdby,GETUTCDATE())                
                
  select SCOPE_IDENTITY() as studentsponsorid                
 end                
 if(@flag=2)---Update Student_ManagerSponser---                
 begin                
  Update student_sponsor set sponsorid=@sponsorid,referenceno=@referenceno,                
  amount=@amount,durationstart=@durationstart,durationend=@durationend,                
  sponsorstatus=@sponsorstatus,updatedby=@createdby,dateupdated=GETUTCDATE()                
  where studentsponsorid=@studentsponsorid                
 end                
 if(@flag=3)---select Student_ManagerSponser---                
 begin           
 select sponsorname,referenceno,amount,CONVERT(varchar(100),DATEDIFF(day,durationstart,durationend)) + '' '' + ''Days''as Duration,studentsponsorid, r.sponsorid                
                
   from student_sponsor s                
   left join ref_sponsor r on s.sponsorid=r.sponsorid                
  where studentid=@studentid and s.DelStatus=0                
  
 end                
 if(@flag=4)---Insert Student_ManagerSponser---                
 begin                
  select referenceno,amount,CONVERT(varchar,durationstart, 3)durationstart,CONVERT(varchar,durationend, 3)durationend                
  ,sponsorstatus,studentsponsorid,sponsorid                
   from student_sponsor                 
  where studentsponsorid=@studentsponsorid                
 end                
 if(@flag=5) ---Del_ManagerSponser---                
 begin                
  Update dbo.student_sponsor set DelStatus=1                
  Where studentsponsorid=@studentsponsorid                
 end                
 if(@flag=6)                
 begin                
  Select * from dbo.ref_sponsor                
 end                
 if(@flag=7)                
 begin                
  select distinct Batch_Code,c.Semester_Name ,cd.Semester_Id                  
  from Tbl_Course_Batch_Duration bd                
  left join Tbl_Course_Duration_PeriodDetails cd on cd.Batch_Id =bd.Batch_Id                
  left join Tbl_Course_Semester c on c.Semester_Id=cd.Semester_Id                
  where bd.Batch_Id=@Batch                
 end                
 if(@flag=8)---Insert tbl_SponsorshipSemDetails                
 begin                
  Insert into tbl_SponsorshipSemDetails (SponsorshipID,SemID,PerSemAmount,DeleteStatus)                
  values(@studentsponsorid,@SemID,@amount,''false'')                
 end                
 if(@flag=9)---Select tbl_SponsorshipSemDetails                
 begin       
       
          
  select SponsorshipID,SemID,PerSemAmount,DeleteStatus from tbl_SponsorshipSemDetails                 
  where SponsorshipID =  @studentsponsorid                
   and DeleteStatus = ''false''                
   and (SemID = @SemID or @SemID=0)                
            
               
     
        
 end                
 if(@flag=10)---Delete  all tbl_SponsorshipSemDetails by SponsorshipID                
 begin                
  update tbl_SponsorshipSemDetails                 
  set DeleteStatus=''true''                
  where SponsorshipID =  @studentsponsorid                
 end                
 if(@flag=11)---Delete  all tbl_SponsorshipSemDetails by SponsorshipID                
 begin                
select SponsorshipID,SemID,PerSemAmount,DeleteStatus from tbl_SponsorshipSemDetails                 
  where SponsorshipID =  @studentsponsorid                
   and DeleteStatus = ''false''                
   and (SemID = @SemID or @SemID=0)                
 end                
                
                 
                
END 
    ')
END
