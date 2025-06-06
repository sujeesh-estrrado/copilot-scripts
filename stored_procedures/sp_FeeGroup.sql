IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_FeeGroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[sp_FeeGroup]
  --[dbo].[sp_FeeGroup]  1,''''              
  @flag                    INT =0,
  @active                  BIT = NULL,
  @programIntakeID         BIGINT=0,
  @IntakeMasterID          BIGINT=0,
  @programid               BIGINT=0,
  @facultyid               BIGINT=0,
  @SearchKeyWord           VARCHAR(50)='''',
  @groupid                 INT=0,
  @groupname               VARCHAR(max)='''',
  @description             VARCHAR(max)='''',
  @totallocal              FLOAT=0,
  @totalintl               FLOAT=0,
  @createdby               INT=0,
  @updatedby               INT =0,
  @groupitemid             BIGINT =0,
  @accountcodeid           BIGINT=0,
  @itemname                VARCHAR(250)='''',
  @amountlocal             FLOAT=0,
  @amountintl              FLOAT=0,
  @remarks                 VARCHAR(255)='''',
  @semester                INT=0,
  @newId                   BIGINT =0,
  @promo                   BIT = false,
  @MinimumAmount           DECIMAL(18, 0)=0,
  @MinAdmissionAmountInter DECIMAL(18, 2)=0,
  @MinAdmissionAmountLocal DECIMAL(18, 2)=0,
  @sem                     INT = 0,
  @type                    VARCHAR(50)='''',
  @StudentID               BIGINT=0,
  @CurrentSem              BIGINT=0,
  @id                      INT =0 output
AS
  BEGIN   
      IF @flag = 1 --Get Fee Groups(Filter & Search)              
        BEGIN
            DECLARE @tep_table TABLE
              (
                 department_id    INT,
                 department_name  VARCHAR(max),
                 course_code      VARCHAR(max),
                 graduationtypeid INT,
                 course_level_id  VARCHAR(max),
                 delete_status    INT,
                 batch_code       VARCHAR(max),
                 batch_id         INT
              )

            INSERT INTO @tep_table
            EXEC Sp_get_programsintake_by_facultyid
              @facultyid

            IF @programIntakeID = 0
              BEGIN
                  SELECT groupid,
                         groupname,
                         [description],
                         programintakeid,
                         programid,
                         totallocal,
                         totalintl,
                         datecreated,
                         createdby,
                         dateupdated,
                         updatedby,
                         active,
                         deletestatus,
                         promotional,
                         minimumamount,
                         minadmissionamountinter,
                         minadmissionamountlocal
                  FROM   dbo.fee_group
                  WHERE  deletestatus = 0
                         --and groupname like ''%DETF%''              
                         --and((programIntakeID  = @programIntakeID) or (@programIntakeID = 0))               
                         AND ( ( active = @active )
                                OR @active IS NULL )
                         AND ( ( programid IN (SELECT department_id
                                               FROM   @tep_table) )
                                OR ( @facultyid = 0 ) )
                         AND ( @SearchKeyWord IS NULL
                                OR ( groupname LIKE ''%'' + @SearchKeyWord + ''%''
                                    --or [description] like ''%''+@SearchKeyWord+''%''               
                                    --or convert(varchar(50),dateupdated,103)  like ''%''+@SearchKeyWord+''%''               
                                    ) )
                  ORDER  BY groupid DESC
              END
            ELSE
              BEGIN
                  SELECT groupid,
                         groupname,
                         [description],
                         programintakeid,
                         programid,
                         totallocal,
                         totalintl,
                         datecreated,
                         createdby,
                         dateupdated,
                         updatedby,
                         active,
                         deletestatus,
                         promotional,
                         minimumamount,
                         minadmissionamountinter,
                         minadmissionamountlocal
                  FROM   dbo.fee_group
                  WHERE  deletestatus = 0
                         --and groupname like ''%DETF%''              
                         AND ( ( programintakeid = @programIntakeID )
                                OR ( @programIntakeID = 0 ) )
                         AND ( ( active = @active )
                                OR @active IS NULL )
                         --and ((programIntakeID in (select Batch_Id from @tep_table )) or (@facultyid = 0))               
                         AND ( @SearchKeyWord IS NULL
                                OR ( groupname LIKE ''%'' + @SearchKeyWord + ''%''
                                    --or [description] like ''%''+@SearchKeyWord+''%''               
                                    --or convert(varchar(50),dateupdated,103)  like ''%''+@SearchKeyWord+''%''               
                                    ) )
                  ORDER  BY groupid DESC
              END
        END

      IF @flag = 2--Insert into [fee_group]              
        BEGIN
            INSERT INTO [dbo].[fee_group]
                        ([groupname],
                         [description],
                         programintakeid,
                         [programid],
                         [totallocal],
                         [totalintl],
                         [datecreated],
                         [createdby],
                         [dateupdated],
                         [updatedby],
                         [active],
                         [deletestatus],
                         [promotional],
                         [minimumamount],
                         [minadmissionamountinter],
                         minadmissionamountlocal)
            VALUES      (@groupname,
                         @description,
                         @programIntakeID,
                         @programid,
                         @totallocal,
                         @totalintl,
                         Getdate(),
                         @createdby,
                         Getdate(),
                         @updatedby,
                         1,
                         0,
                         @promo,
                         @MinimumAmount,
                         @MinAdmissionAmountInter,
                         @MinAdmissionAmountLocal)

            SET @id=Scope_identity()

            SELECT @id AS FeeGroup
        --if not exists(select * from fee_group where groupname =@groupname)              
        --begin              
        --end              
        --else              
        --begin              
        --set @groupname = CONCAT(@groupname,''_'',Getdate(),''_Promo'')              
        -- SET NOCOUNT ON;              
        -- INSERT INTO [dbo].[fee_group]([groupname],[description],programIntakeID,[programid],[totallocal],              
        --[totalintl],[datecreated],[createdby],[dateupdated],[updatedby],[active],[deleteStatus],[Promotional],              
        -- [MinimumAmount],[MinAdmissionAmountInter],MinAdmissionAmountLocal)              
        -- VALUES              
        --  (@groupname,@description,@programIntakeID,@programid,@totallocal,@totalintl,getdate(),              
        --  @createdby,getdate(),@updatedby,1,0,@promo,@MinimumAmount,@MinAdmissionAmountInter,@MinAdmissionAmountLocal)              
        --  SET @id=SCOPE_IDENTITY()              
        --  select  @id as FeeGroup              
        --end              
        END

      IF @flag = 3 --Update Total Amount(Local & International)              
        BEGIN
            UPDATE [fee_group]
            SET    [totallocal] = (SELECT Sum(amountlocal)
                                   FROM   fee_group_item
                                   WHERE  groupid = @groupid
                                          AND deletestatus = 0),
                   [totalintl] = (SELECT Sum(amountintl)
                                  FROM   fee_group_item
                                  WHERE  groupid = @groupid
                                         AND deletestatus = 0)
            WHERE  groupid = @groupid
        END

      IF @flag = 4 --Update fee group active status              
        BEGIN
            UPDATE [fee_group]
            SET    [active] = (SELECT ~[active]
                               FROM   [fee_group]
                               WHERE  groupid = @groupid),
                   dateupdated = Getdate()
            WHERE  groupid = @groupid

            SELECT active
            FROM   fee_group
            WHERE  groupid = @groupid
        END

      IF @flag = 5 --Insert Fee Group Item              
        BEGIN
            INSERT INTO [fee_group_item]
                        ([accountcodeid],
                         [itemname],
                         [amountlocal],
                         [amountintl],
                         [remarks],
                         [groupid],
                         [semester],
                         [datecreated],
                         [createdby],
                         [dateupdated],
                         [updatedby],
                         [deletestatus])
            VALUES      (@accountcodeid,
                         @itemname,
                         @amountlocal,
                         @amountintl,
                         @remarks,
                         @groupid,
                         @semester,
                         Getdate(),
                         @createdby,
                         Getdate(),
                         @updatedby,
                         0)
        END

      IF @flag = 6 --Get Fee Group Details By ID              
        BEGIN
            SELECT groupid,
                   groupname,
                   [description],
                   programintakeid,
                   programid,
                   totallocal,
                   totalintl,
                   minimumamount,
                   minadmissionamountinter,
                   minadmissionamountlocal,
                   datecreated,
                   createdby,
                   dateupdated,
                   updatedby,
                   active,
                   deletestatus,
                   promotional
            FROM   dbo.fee_group
            WHERE  groupid = @groupid
        END

      IF @flag = 7 --Get Fee Group Items Details By FeeGroupID              
        BEGIN
            SELECT FGI.groupitemid,
                   FGI.accountcodeid,
                   AC.code,
                   AC.NAME,
                   AC.deletestatus,
                   AC.active,
                   FGI.itemname,
                   FGI.amountlocal,
                   FGI.amountintl,
                   FGI.remarks,
                   FGI.groupid,
                   FGI.semester,
                   FGI.datecreated,
                   FGI.createdby,
                   FGI.dateupdated,
                   FGI.updatedby,
                   FGI.deletestatus AS fee_group_item_delete_status,
                   CS.semester_name
            FROM   dbo.fee_group_item AS FGI
                   INNER JOIN dbo.ref_accountcode AS AC
                           ON FGI.accountcodeid = AC.id
                   LEFT JOIN dbo.tbl_course_semester AS CS
                          ON FGI.semester = CS.semester_id
            WHERE  ( FGI.groupid = @groupid )
                   AND ( FGI.deletestatus = 0 )
        END

      IF @flag = 8 --Get Fee Group Details By programIntakeID              
        BEGIN
            SELECT groupid,
                   groupname,
                   [description],
                   programintakeid,
                   programid,
                   totallocal,
                   totalintl,
                   datecreated,
                   createdby,
                   dateupdated,
                   updatedby,
                   active,
                   deletestatus,
                   promotional,
                   minadmissionamountinter,
                   minadmissionamountlocal
            FROM   dbo.fee_group
            WHERE  programintakeid = @programIntakeID
                   AND deletestatus = 0
        END

      IF @flag = 9 --Delete Fee Group              
        BEGIN
        IF NOT EXISTS(SELECT * FROM tbl_student_accountgroup_map WHERE FeeGroupID = @groupid)
            BEGIN
                UPDATE [fee_group]
                SET deletestatus = 1
                WHERE  groupid = @groupid
            END         
        END

      IF @flag = 10 --Get Fee Group Item by FeeGroupItemID              
        BEGIN
            SELECT FGI.groupitemid,
                   FGI.accountcodeid,
                   FGI.itemname,
                   FGI.amountlocal,
                   FGI.amountintl,
                   FGI.groupid,
                   FGI.semester,
                   FGI.deletestatus,
                   AC.NAME          AS AccountCode,
                   CS.semester_name AS Semester
            FROM   dbo.fee_group_item AS FGI
                   INNER JOIN dbo.ref_accountcode AS AC
                           ON FGI.accountcodeid = AC.id
                   INNER JOIN dbo.tbl_course_semester AS CS
                           ON FGI.groupid = CS.semester_id
            WHERE  FGI.groupitemid = @groupitemid
        END

      IF @flag = 11
        --Update Fee Group Item by FeeItemID              
        BEGIN
            UPDATE [dbo].[fee_group_item]
            SET    [amountlocal] = @amountlocal,
                   [amountintl] = @amountintl,
                   [dateupdated] = Getdate(),
                   [updatedby] = @updatedby,
                   deletestatus = 0
            WHERE  groupitemid = @groupitemid
        --[semester] = @semester and accountcodeid = @accountcodeid              
        END

      IF @flag = 12 --Delete Fee Group Item by FeegroupItemID              
        BEGIN
            UPDATE [dbo].[fee_group_item]
            SET    deletestatus = 1,
                   [dateupdated] = Getdate(),
                   [updatedby] = @updatedby
            WHERE  groupitemid = @groupitemid
        --[semester] = @semester and accountcodeid = @accountcodeid              
        END

      IF @flag = 13
        --Get Fee Group Details By Program ID Active and Non-Promotional              
        BEGIN
            SELECT groupid,
                   groupname,
                   [description],
                   programid,
                   totallocal,
                   totalintl,
                   datecreated,
                   createdby,
                   dateupdated,
                   updatedby,
                   active,
                   deletestatus,
                   promotional,
                   minimumamount,
                   minadmissionamountinter,
                   minadmissionamountlocal
            FROM   dbo.fee_group
            WHERE  programintakeid = @programIntakeID
                   AND deletestatus = 0
                   AND active = 1
                   AND promotional = 0
        END

      IF @flag = 14
        --Get Fee Group Details By Program ID and Promotional only              
        BEGIN
            SELECT groupid,
                   groupname,
                   [description],
                   programid,
                   totallocal,
                   totalintl,
                   datecreated,
                   createdby,
                   dateupdated,
                   updatedby,
                   active,
                   deletestatus,
                   promotional,
                   minimumamount,
                   minadmissionamountinter,
                   minadmissionamountlocal
            FROM   dbo.fee_group
            WHERE  programintakeid = @programIntakeID
                   AND deletestatus = 0
                   AND active = 1
                   AND promotional = 1
        END

      IF @flag = 15
        --Get Fee Group Items Details By FeeGroupID and Semester no              
        BEGIN
            SELECT FGI.groupitemid,
                   FGI.accountcodeid AS Account_CodeID,
                   AC.code,
                   AC.NAME,
                   AC.deletestatus,
                   AC.active,
                   FGI.itemname,
                   FGI.amountlocal,
                   FGI.amountintl,
                   FGI.remarks,
                   FGI.groupid,
                   FGI.semester,
                   FGI.datecreated,
                   FGI.createdby,
                   FGI.dateupdated,
                   FGI.updatedby,
                   FGI.deletestatus  AS fee_group_item_delete_status,
                   CS.semester_name
            FROM   dbo.fee_group_item AS FGI
                   INNER JOIN dbo.ref_accountcode AS AC
                           ON FGI.accountcodeid = AC.id
                   LEFT OUTER JOIN dbo.tbl_course_semester AS CS
                                ON FGI.semester = CS.semester_id
            WHERE  ( FGI.deletestatus = 0 )
                   AND ( FGI.groupid = @groupid )
                   AND ( FGI.semester = @sem )
        END

      IF @flag = 16 --Get Fee Group ID  By @groupname              
        BEGIN
            SELECT groupid
            FROM   fee_group
            WHERE  groupname = @groupname
        END

      IF @flag = 17--Update [fee_group]              
        BEGIN
            IF NOT EXISTS(SELECT *
                          FROM   fee_group
                          WHERE  groupname = @groupname
                                 AND groupid != @id)
              BEGIN
                  UPDATE [dbo].[fee_group]
                  SET   [groupname] = @groupname,
                        [description] = @description,
                        [dateupdated] = Getdate(),
                        [updatedby] = @updatedby,
                        [minimumamount] = @MinimumAmount,
                        minadmissionamountinter = @MinAdmissionAmountInter,
                        minadmissionamountlocal = @MinAdmissionAmountLocal
                  WHERE  groupid = @id
              END
            ELSE
              BEGIN
                  SET @groupname = Concat(@groupname, ''_'', Getdate(), ''_Promo'')

                  UPDATE [dbo].[fee_group]
                  SET   [groupname] = @groupname,
                        [description] = @description,
                        [dateupdated] = Getdate(),
                        [updatedby] = @updatedby,
                        [minimumamount] = @MinimumAmount,
                        minadmissionamountinter = @MinAdmissionAmountInter,
                        minadmissionamountlocal = @MinAdmissionAmountLocal
                  WHERE  groupid = @id
              END
        END

      IF( @flag = 18 )
        BEGIN
            SELECT DISTINCT FGI.accountcodeid,
                            AC.NAME
            FROM   dbo.fee_group_item AS FGI
                   INNER JOIN dbo.ref_accountcode AS AC
                           ON FGI.accountcodeid = AC.id
                   LEFT JOIN dbo.tbl_course_semester AS CS
                          ON FGI.semester = CS.semester_id
            WHERE  ( FGI.deletestatus = 0 )
                   AND ( FGI.groupid = @groupid )
        END

      IF( @flag = 19 ) --Intake not Mapped with Feegroup              
        BEGIN
            SELECT Count(batch_id)AS notfeegroupIntakes
            FROM   tbl_course_batch_duration
            WHERE  batch_id NOT IN(SELECT programintakeid
                                   FROM   fee_group)
        END

      IF( @flag = 20 )
        --Master Intake with Inatake having FeegGroups              
        BEGIN
            SELECT DISTINCT intakemasterid,
                            IM.batch_code AS intake_no,
                            IM.batch_from
            FROM   fee_group AS FG
                   JOIN tbl_course_batch_duration AS CBD
                     ON FG.programintakeid = CBD.batch_id
                   LEFT JOIN tbl_intakemaster AS IM
                          ON IM.id = CBD.intakemasterid
            WHERE  FG.deletestatus = 0
                   AND active = 1
                   AND promotional = 0
                   AND programintakeid IS NOT NULL
                    OR programintakeid = 0
            ORDER  BY IM.batch_from DESC
        END

      IF( @flag = 21 )
        --Get FeeGroups and Intake by IntakeMasterID              
        BEGIN
            SELECT batch_id,
                   batch_code,
                   groupid,
                   groupname,
                   intakemasterid,
                   intake_no,
                   CBD.duration_id,
                   D.course_code,
                   Concat(D.course_code, '' - '', D.department_name) AS
                   Department_Name
            FROM   fee_group AS FG
                   JOIN tbl_course_batch_duration AS CBD
                     ON FG.programintakeid = CBD.batch_id
                   JOIN tbl_department AS D
                     ON D.department_id = CBD.duration_id
            WHERE  deletestatus = 0
                   AND active = 1
                   AND promotional = 0
                   AND ( programintakeid IS NOT NULL
                          OR programintakeid = 0 )
                   AND intakemasterid = @IntakeMasterID
        END

      IF( @flag = 22 )
        --Get Programmes without Active-NonPromotional Feegroup with IntakeMasterID              
        BEGIN
            SELECT batch_id,
                   batch_code,
                   CBD.duration_id,
                   D.department_name,
                   D.course_code
            FROM   tbl_course_batch_duration AS CBD
                   JOIN tbl_department AS D
                     ON D.department_id = CBD.duration_id
            WHERE  D.active_status = ''Active''
                   AND delete_status = 0
                   AND CBD.batch_id NOT IN(SELECT programintakeid
                                           FROM   fee_group
                                           WHERE  deletestatus = 0
                                                  AND active = 1
                                                  AND promotional = 0)
                   AND batch_delstatus = 0
                   AND intakemasterid = @IntakeMasterID
            ORDER  BY department_name
        END

      IF( @flag = 23 )
        --Get FeeGroups and Intake by IntakeMasterID and Programme              
        BEGIN
            SELECT batch_id,
                   batch_code,
                   groupid,
                   groupname,
                   intakemasterid,
                   intake_no,
                   CBD.duration_id,
                   D.department_name,
                   D.course_code,
                   FG.totallocal,
                   FG.totalintl,
                   FG.minimumamount,
                   FG.minadmissionamountinter,
                   FG.minadmissionamountlocal
            FROM   fee_group AS FG
                   JOIN tbl_course_batch_duration AS CBD
                     ON FG.programintakeid = CBD.batch_id
                   JOIN tbl_department AS D
                     ON D.department_id = CBD.duration_id
            WHERE  deletestatus = 0
                   AND active = 1
                   AND promotional = 0
                   AND ( programintakeid IS NOT NULL
                          OR programintakeid = 0 )
                   AND department_id = @programid
                   AND intakemasterid = @IntakeMasterID
            ORDER  BY CBD.intakemasterid,
                      department_name
        END

      IF( @flag = 24 )
        --Get FeeGroup Details by StudentID(if FeeGroup mapped)          
        BEGIN
            SELECT FGI.groupitemid,
                   FGI.accountcodeid,
                   AC.code,
                   AC.NAME,
                   AC.deletestatus,
                   AC.active,
                   FGI.itemname,
                   FGI.amountlocal,
                   FGI.amountintl,
                   FGI.remarks,
                   FGI.groupid,
                   FGI.semester,
                   FGI.datecreated,
                   FGI.createdby,
                   FGI.dateupdated,
                   FGI.updatedby,
                   FGI.deletestatus AS fee_group_item_delete_status,
                   CS.semester_name
            FROM   [tbl_student_accountgroup_map] FGM
                   JOIN fee_group_item FGI
                     ON FGI.groupid = FGM.feegroupid
                   JOIN ref_accountcode AS AC
                     ON FGI.accountcodeid = AC.id
                   LEFT JOIN tbl_course_semester AS CS
                          ON FGI.semester = CS.semester_id
            WHERE  FGM.studentid = @StudentID
                   AND FGM.deletestatus = 0
        END

      IF( @flag = 25 )
        --Get FeeGroup Details by StudentID(if FeeGroup mapped)          
        BEGIN
            SELECT FGI.semester,
                   CS.semester_name
            FROM   [tbl_student_accountgroup_map] FGM
                   JOIN fee_group_item FGI
                     ON FGI.groupid = FGM.feegroupid
                   JOIN ref_accountcode AS AC
                     ON FGI.accountcodeid = AC.id
                   LEFT JOIN tbl_course_semester AS CS
                          ON FGI.semester = CS.semester_id
            WHERE  FGM.studentid = @StudentID
                   AND FGM.deletestatus = 0
                   AND FGI.semester > @CurrentSem
            GROUP  BY FGI.semester,
                      CS.semester_name
        END

      IF @flag = 26
        --Get Fee Group Items Details By FeeGroupID and Semester no and Student Type          
        BEGIN
            SELECT FGI.groupitemid,
                   FGI.accountcodeid AS Account_CodeID,
                   AC.code,
                   AC.NAME,
                   AC.deletestatus,
                   AC.active,
                   FGI.itemname,
                   CASE
                     WHEN @type = ''2'' THEN
                     CONVERT(DECIMAL(18, 2), FGI.amountlocal
                     )
                     WHEN @type = ''1'' THEN
                     CONVERT(DECIMAL(18, 2), FGI.amountintl)
                   END               AS Amount,
                   FGI.remarks,
                   FGI.groupid,
                   FGI.semester,
                   FGI.datecreated,
                   FGI.createdby,
                   FGI.dateupdated,
                   FGI.updatedby,
                   FGI.deletestatus  AS fee_group_item_delete_status,
                   CS.semester_name
            FROM   dbo.fee_group_item AS FGI
                   INNER JOIN dbo.ref_accountcode AS AC
                           ON FGI.accountcodeid = AC.id
                   LEFT OUTER JOIN dbo.tbl_course_semester AS CS
                                ON FGI.semester = CS.semester_id
            WHERE  ( FGI.deletestatus = 0 )
                   AND ( FGI.groupid = @groupid )
                   AND ( FGI.semester = @sem )
                   AND ( ( @type = ''2''
                           AND FGI.amountlocal > 0 )
                          OR ( @type = ''1''
                               AND FGI.amountintl > 0 ) )
        END

      IF( @flag = 27 )
        --Get Programmes without Active-NonPromotional Feegroup with Programme and IntakeMaster             
        BEGIN
            SELECT batch_id,
                   batch_code,
                   CBD.duration_id,
                   D.department_name,
                   D.course_code,
                   Concat(D.department_name, ''-'', D.course_code) AS Programme
            FROM   tbl_course_batch_duration AS CBD
                   JOIN tbl_department AS D
                     ON D.department_id = CBD.duration_id
            WHERE  D.active_status = ''Active''
                   AND delete_status = 0
                   AND CBD.batch_id NOT IN(SELECT programintakeid
                                           FROM   fee_group
                                           WHERE  deletestatus = 0
                                                  AND active = 1
                                                  AND promotional = 0)
                   AND batch_delstatus = 0
                   AND ( intakemasterid = @IntakeMasterID
                          OR @IntakeMasterID = 0 )
                   AND ( department_id = @programid
                          OR @programid = 0 )
                   AND ( D.graduationtypeid = @facultyid
                          OR @facultyid = 0 )
                   AND intakemasterid > 148
            ORDER  BY batch_code
        END
  END
    ')
END
