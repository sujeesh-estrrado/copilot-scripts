IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_student_count]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Sp_Get_student_count] --''Preactivated'',''ARUN SB''
(
@status varchar(max)=null,
@SearchKeyWord varchar(max) =null,
@flag bigint=0,
@counselorid bigint=0
)
As 

  begin
  if @flag=0
  begin
 

 select count(candidate_id) from Tbl_Candidate_Personal_Det as CPD where CPD.ApplicationStatus=@status and
  ((concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) like  ''%''+ @searchkeyword +''%'') 
                                or (CPD.Candidate_Lname like  ''%''+ @searchkeyword +''%'')  
                                or(CPD.AdharNumber like ''%''+ @searchkeyword +''%'' )
                                or (CPD.IDMatrixNo like ''%''+ @searchkeyword +''%'' ) 
                                or(CPD.Candidate_Id like ''%''+ @searchkeyword +''%'' ) 
                                or concat(CPD.Candidate_Fname,'''',CPD.Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')
                                or @searchkeyword='''') and Candidate_DelStatus=0 
                                end
        if @flag=2
        begin
         select count(candidate_id) from Tbl_Candidate_Personal_Det as CPD where CPD.ApplicationStatus=@status and
  ((concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) like  ''%''+ @searchkeyword +''%'') 
                                or (CPD.Candidate_Lname like  ''%''+ @searchkeyword +''%'')  
                                or(CPD.AdharNumber like ''%''+ @searchkeyword +''%'' )
                                or (CPD.IDMatrixNo like ''%''+ @searchkeyword +''%'' ) 
                                or(CPD.Candidate_Id like ''%''+ @searchkeyword +''%'' ) 
                                or concat(CPD.Candidate_Fname,'''',CPD.Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')
                                or @searchkeyword='''') and Candidate_DelStatus=0 and (CounselorEmployee_id=@counselorid or @counselorid=0)
        end
        if @flag=5
        begin
         select count(candidate_id) from Tbl_Candidate_Personal_Det as CPD where CPD.ApplicationStatus=@status and
  ((concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) like  ''%''+ @searchkeyword +''%'') 
                                or (CPD.Candidate_Lname like  ''%''+ @searchkeyword +''%'')  
                                or(CPD.AdharNumber like ''%''+ @searchkeyword +''%'' )
                                or (CPD.IDMatrixNo like ''%''+ @searchkeyword +''%'' ) 
                                or(CPD.Candidate_Id like ''%''+ @searchkeyword +''%'' ) 
                                or concat(CPD.Candidate_Fname,'''',CPD.Candidate_Lname) like concat(''%'',@searchkeyword ,''%'')
                                or @searchkeyword='''') and Candidate_DelStatus=0 and (Agent_ID=@counselorid or @counselorid=0)
        end
                                                 end
    ')
END;
