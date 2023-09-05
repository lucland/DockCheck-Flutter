/// Write here every color you need use in the app to get them centralize
class ForgeStrings {
  ForgeStrings._();

  static const String welcomeToCriptoQrApp = 'Welcome to the Cripto QR App!';
  static const String useTheAppToViewYourSchedule =
      'Use this app to view your schedule, and to clock in, clock out, and submit your timesheet each day.';
  static const String tapTheButtonBelow =
      'Tap the button below to sign in with your Forge email.';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signInFailed =
      'Something went wrong and we were unable to sign you in. Please try again.';
  static const String schedule = 'Schedule';
  static const String timesheet = 'Timesheet';
  static const String profile = 'Profile';
  static const String clockIn = 'Clock In';
  static const String clockOut = 'Clock Out';
  static const String accountInfo = 'Account information';
  static const String name = 'Name';
  static const String email = 'Email';
  static const String signOut = 'Sign out';
  static const String weeklySummary = 'Weekly summary';
  static const String expectedPaidTime = 'Expected paid time';
  static const String totalPaidTime = 'Total paid time';
  static const String totalWorkingHours = 'Total working hours';
  static const String areYouSure = 'Are you sure that you want to sign out?';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String clockedIn = 'Clocked in';
  static const String clockedOut = 'Clocked out';
  static const String submit = 'Submit';
  static const String trailingHyphens = '--';
  static const String setTime = 'Set time';
  static const String clockedTime = 'Clocked time';
  static const String youHaveNotClockedIn = 'You have not clocked in';
  static const String youHaveClocked = 'You have clocked';
  static const String youClocked = 'You clocked';
  static const String yourTimesheetHas = 'Your timesheet has';
  static const String done = 'Done';
  static const String hour = 'Hour';
  static const String hours = 'Hours';
  static const String minutes = 'Minutes';
  static const String amPm = 'AM / PM';
  static const String amTile = 'AM';
  static const String pmTile = 'PM';
  static const String timesheetSectionOtherActivities = 'Other Activities';
  static const String getDirections = 'Get Directions';
  static const String viewJobDetails = 'View details, notes & files';
  static const String viewEventDetails = 'View event details';
  static const String joinZoomCall = 'Join Zoom call';
  static const String zoomVideoCall = 'Zoom Video Call';
  static const String selectWeek = 'Select Week';
  static const String appointments = 'Appointments';
  static const String partnerJob = 'Partner Job';
  static const String customer = 'Customer';
  static String youHaveNAppointments(int n) =>
      'You have $n appointment${n != 1 ? 's' : ''} today';
  static const String error = 'ERROR';
  static const String scheduleNoConnectionTitle =
      'We can\'t load your schedule without service';
  static const String scheduleNoConnectionSubTitle =
      'We need cell service to load your schedule. Once you have better service,'
      ' tap "Refresh" to view schedule details.';
  static const String refresh = 'Refresh';
  static const String loading = 'Loading...';
  static const String loadingSchedule = 'Loading schedule...';
  static const String youHaveNoAppointments = 'You have no appointments today';
  static const String itIsAMistake =
      'Do you think this is a mistake? Refresh the page to try again.';
  static const String addActivity = 'Add Activity';
  static const String addJobPrep = 'Add Job Prep';
  static const String addActivityToTimesheet = '+ Add timesheet activity';
  static const String add = '+ Add';
  static const String noMoreActivitiesToAdd = 'Event list empty...';
  static const String addJobPrepInstructions =
      'Select the job that you prepped for today. If you completed prep activities for more than one job, select “Other”.';
  static const String other = 'Other';
  static const String delete = 'Delete';
  static const String deleteLineItem = 'Delete from timesheet';
  static const String tapToType = 'Tap to type';
  static const String notesJobPrepTitle = 'Job Prep Note';
  static const String confirmNotesJobPrepTitle = 'Confirm Job Prep Note';
  static const String notesOtherTitle = 'Other Paid Time';
  static const String confirmNotesOtherTitle = 'Confirm Other Paid Time';
  static const String continueButton = 'Continue';
  static const String submitTimesheet = 'Submit Timesheet';
  static const String notesJobPrepDescription =
      'Please describe the job prep activities you completed today.';
  static const String notesOtherDescription =
      'Please provide a brief description of your activities during this time.';
  static const String errorTitlePaidSummary =
      'We can’t load your paid time without service';
  static const String errorBodyPaidSummary =
      'We need cell service to load your paid time. Once you have better service, tap “Refresh” to view schedule details.';
  static const String loadingTimesheet = 'Loading timesheet...';
  static const String timesheetNoConnectionTitle =
      'We can’t load your timesheet';
  static const String timesheetNoConnectionSubTitle =
      'We need cell service to load your timesheet. Once you have better service, tap “Refresh”.';
  static const String timesheetMismatchWarning =
      'Your clocked time and timesheet hours must match before you can submit';
  static String timesheetMatchMessage(String time) =>
      'This includes $time of paid time';
  static String timesheetCompleteMessage(String day) =>
      'You submitted your timesheet for $day';
  static const String description = 'Description';
  static const String errorTitleJobDetails = 'We can\'t load job details';
  static const String errorBodyJobDetails =
      'Something went wrong, and we are unable to load job details. Tap “Refresh” to try again.';
  static const String errorTitleJobNotes = 'We can\'t load job notes';
  static const String errorBodyJobNotes =
      'Something went wrong, and we are unable to load job notes. Tap “Refresh” to try again.';
  static const String deleteJobNotesFailure =
      'Something went wrong and we were unable to delete the note.\nPlease try again.';
  static const String jobNoteSaveFailure =
      'Something went wrong and we were unable to save your changes. Please try again.';
  static const String deleteJobNotesSuccess = 'Note successfully deleted';
  static const String errorTitleJobContacts = 'We can\'t load job contacts';
  static const String errorBodyJobContacts =
      'Something went wrong, and we are unable to load job contacts. Tap “Refresh” to try again.';
  static const String errorTitleJobFiles = 'We can\'t load job files';
  static const String errorBodyJobFiles =
      'Something went wrong, and we are unable to load job files. Tap “Refresh” to try again.';
  static const String errorBodyFile =
      'Something went wrong, and we are unable to load this file. Tap “Refresh” to try again.';
  static const String errorBodyImage =
      'Something went wrong, and we are unable to load this photo. Tap “Refresh” to try again.';
  static const String loadingJobDetails = 'Loading job details...';
  static const String loadingJobNotes = 'Loading job notes...';
  static const String loadingJobContacts = 'Loading job contacts...';
  static const String loadingJobFiles = 'Loading job files...';
  static const String loadingFile = 'Loading file...';
  static const String cantLoadFile = 'We can’t load this file';
  static const String cantLoadPhoto = 'We can’t load this photo';
  static const String emptyContactsTitle =
      'There are no contacts associated with this job';
  static const String emptyContactsBody =
      'If you think this is a mistake, contact your Project Coordinator.';
  static const String expandDescription = 'Expand description';
  static const String collapseDescription = 'Collapse description';
  static const String expandDetails = 'Expand details';
  static const String collapseDetails = 'Collapse details';
  static const String expand = 'Expand';
  static const String collapse = 'Collapse';
  static const String appointmentDetails = 'Appointment Details';
  static const String lowerDescription = 'description';
  static const String eventDetails = 'Event Details';
  static const String jobDetails = 'Job Details';
  static const String jobDescription = 'Job Description';
  static const String details = 'Details';
  static const String notes = 'Notes';
  static const String files = 'Files';
  static const String viewJobFiles = 'View job files';
  static const String contacts = 'Contacts';
  static const String comingUp = 'Coming Up';
  static const String videoCall = 'Video call';
  static const String noAppointmentsSchedule = 'No appointments scheduled';
  static const String tentative = 'TENTATIVE';
  static const String call = 'Call';
  static const String partner = 'Partner';
  static const String directionsWarningTitleAppt =
      'You are getting directions to a future appointment.';
  static const String directionsWarningTitleEvent =
      'You are getting directions to a future event.';
  static const String directionsWarningDescriptionAppt =
      'If you are looking for directions to your current day’s appointment, '
      'tap “Cancel” and return to your Schedule page.\n'
      'If you want directions to this future appointment, tap “Continue”.';
  static const String directionsWarningDescriptionEvent =
      'If you are looking for directions to your current day’s event, '
      'tap “Cancel” and return to your Schedule page.\n'
      'If you want directions to this future event, tap “Continue”.';
  static String missingTimesheetHello(String name) => 'Hello $name,';
  static String missingTimesheetMessagePlural(count) =>
      'You have $count missing timesheets';
  static const String missingTimesheetMessageSingular =
      'You have 1 missing timesheet';
  static const String missingTimesheetMessageNone =
      'You have no missing timesheets';
  static const String missingTimesheetInstructions =
      'Review each missing timesheet to go to today’s schedule.';
  static const String missingTimesheetReview = 'Review';
  static const String missingTimesheetFillOutAction = 'Fill out timesheet';
  static const String missingTimesheetMarkPaidAction = 'Mark as paid day off';
  static const String missingTimesheetMarkUnpaidAction = 'Mark as unpaid day';
  static const String missingTimesheetMarkHolidayAction =
      'Mark as company holiday';
  static const String missingTimesheetConfirmDescription =
      'You cannot undo this action.';
  static String missingTimesheetConfirmPaidTitle(String day) =>
      'Are you sure you want to mark $day as a paid day?';
  static String missingTimesheetConfirmUnpaidTitle(String day) =>
      'Are you sure you want to mark $day as an unpaid day?';
  static String missingTimesheetConfirmHolidayTitle(String day) =>
      'Are you sure you want to mark $day as a company holiday?';
  static String timesheetSubmissionSuccess(String day) =>
      'Your timesheet for $day was submitted successfully';
  static const String benchTimeDescription =
      'This time is paid until you reach your minimum weekly guaranteed hours.';
  static const String missingTimesheetTitle = 'Missing Timesheet';

  static const String appUpdatePageHeader =
      'There is a new app update available';
  static const String appUpdatePageBodyLine1 =
      'You must update your Field Hub app before you can continue.';
  static const String appUpdatePageBodyLine2 =
      'Tap the button below to go to your device’s app store where you can download the update. This should only take a few minutes.';
  static const String downloadUpdate = 'Download Update';
  static const String viewExpectedPaidTime = 'View expected paid time';
  static const String viewTotalPaidTime = 'View total paid time';
  static const String thisWeek = 'This week';
  static const String lastWeek = 'Last week';
  static String timesheetTrueUpTitle(int hours) =>
      'You have clocked less than your expected $hours hour shift today';
  static const String timesheetTrueUpDescription =
      'How did you spend the rest of your working hours?';
  static const String timesheetTrueUpOptionBenchDescription =
      'You were available to Forge but were told not to report anywhere.';
  static const String expectedPaidTimeDescriptionTitle =
      'What is “expected paid time”?';
  static const String expectedPaidTimeDescription =
      'Your “expected paid time” shows how many paid hours you will have accumulated at the end of the week. This number will be increased or decreased by any additional overtime work or unpaid time off.';
  static String minimumWeeklyHoursDescriptionTitle =
      'What are my minimum weekly hours?';
  static String minimumWeeklyHoursDescription =
      'Currently, you are guaranteed at least 40 hours of work a week. This time includes any voluntary paid or unpaid time off.';
  static const String workingHours = 'Working hours';
  static const String paidTimeOff = 'Paid time off';
  static const String unpaidTime = 'Unpaid time';
  static const String benchTime = 'Bench time';
  static String appointmentsLength(int length) =>
      'This job has $length appointments';
  static const String oneAppointment = 'This job has 1 appointment';
  static String longArriveWindow(String start, String end) =>
      'Arrive between $start and $end';
  static String arriveWindow(String time) => 'Arrive at $time';
  static const String future = 'FUTURE';
  static const String today = 'TODAY';
  static const String past = 'PAST';
  static const String appointmentPicker =
      'Below are all the appointments scheduled for this job.';
  static const String jobNotesHint = 'Tap to add new note';
  static const unknown = 'Unknown';
  static const String editNote = 'Edit note';
  static const String deleteNote = 'Delete note';
  static const String deleteNoteConfirmationTitle =
      'Are you sure you want to delete this note?';
  static const String thisActionCannotBeUndone =
      'This action cannot be undone.';
  static const String documents = 'Documents';
  static const String noDocumentsUploaded = 'No documents uploaded';
  static const String noPhotosUploaded = 'No photos uploaded';
  static const String uploadDocument = 'Upload document';
  static const String uploadFiles = 'Upload files';
  static const String view = 'View';
  static const String photos = 'Photos';
  static const String uploadPhotos = 'Upload photos';
  static const String loadingPhotos = 'Loading photos...';
  static const String resources = 'Resources';
  static const String helpGuide = 'View Help Guide';
  static const String privacyPolicy = 'View Privacy Policy';
  static const String needHelpWithMissingTimesheets =
      'Need help with missing timesheets?';
  static const String needHelpWithUpdatingYourApp =
      'Need help with updating your app?';
  static const String downloadPhoto = 'Share/save photo';
  static const String renamePhoto = 'Rename photo';
  static const String deletePhoto = 'Delete photo';
  static const String downloadDocument = 'Share/save document';
  static const String renameDocument = 'Rename document';
  static const String deleteFile = 'Delete document';
  static const String deleteFileConfirmation =
      'Are you sure you want to delete this document?';
  static const String deletePhotoConfirmation =
      'Are you sure you want to delete this photo?';
  static const String post = 'Post';
  static const String save = 'Save';
  static const String isEdited = ' | Edited';
  static const String untitled = 'Untitled';
  static const String workOrder = 'Work Order';
  static const String rename = 'Rename';
  static const String renameFailure =
      'There was an error saving your changes. Please try again.';
  static const String uploading = 'Uploading...';
  static const String imageTypeError =
      'Files must be JPG, PNG, HEIC, or PDF file types.';
  static const String imageSizeError = 'Files must be less than 25 MB';
  static const String tryAnewFile = 'Try a new file';
  static const String tryAgain = 'Try again';
  static const String imageUnknownError =
      'Something went wrong and we were unable to complete the file upload. Please try again.';
  static const String updatePermissions =
      'To upload photos, please update your app permissions';
  static const String updatePermissionsDescription =
      'Please go to your Settings app, and enable Photos permissions for the Field Hub app.';
  static const String goToSettings = 'Go to Settings';
  static String uploadedBy(String name, String date) =>
      'Uploaded by $name on $date';
}
