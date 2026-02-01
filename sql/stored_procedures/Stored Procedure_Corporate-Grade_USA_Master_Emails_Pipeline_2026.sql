
-------How to RUN the stored procedure (every time)

------After loading CSV into staging_emails:

EXEC dbo.usp_Process_USA_Master_Emails;




CREATE OR ALTER PROCEDURE dbo.usp_Process_USA_Master_Emails
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        /* =====================================================
           STEP 1: Normalize emails
        ===================================================== */
        UPDATE staging_emails
        SET email = LOWER(LTRIM(RTRIM(email)));

        UPDATE usa_master_emails
        SET email = LOWER(LTRIM(RTRIM(email)));

        /* =====================================================
           STEP 2: Capture duplicates (against existing master)
        ===================================================== */
        INSERT INTO usa_duplicate_emails
        (
            email,
            source,
            country,
            duplicate_reason,
            captured_date
        )
        SELECT
            s.email,
            s.source,
            s.country,
            'Already exists in usa_master_emails',
            GETDATE()
        FROM staging_emails s
        WHERE EXISTS
        (
            SELECT 1
            FROM usa_master_emails u
            WHERE u.email = s.email
        );

        /* =====================================================
           STEP 3: Insert ONLY new emails into master
        ===================================================== */
        INSERT INTO usa_master_emails
        (
            email,
            source,
            country,
            created_date
        )
        SELECT
            s.email,
            s.source,
            s.country,
            GETDATE()
        FROM staging_emails s
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM usa_master_emails u
            WHERE u.email = s.email
        );

        /* =====================================================
           STEP 4: Clear staging
        ===================================================== */
        TRUNCATE TABLE staging_emails;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO
