# BUG REPORTS

---

### **BUG 1: Cannot go back if new note is empty** [RESOLVED]

**Issue:** When creating a new note, if the user leaves both the title and body fields empty, they cannot navigate back to the previous screen.

**Root Cause (`reason of triggering the bug report file`):**
The bug is in `lib/features/home/screens/note/note_detail_page.dart`. The `_saveNote()` function is called when the user tries to go back. This function correctly avoids saving a new, empty note. However, it fails to call `Navigator.of(context).pop()` in this scenario, which means the page is never dismissed, trapping the user.

**Solution:**
Modify the `_saveNote()` function. Add a specific check at the beginning: if the note is new (`widget.note?.id == null`) and both text controllers are empty, the function should immediately call `Navigator.of(context).pop()` and exit. This allows the user to discard an empty new note and return to the list screen.

---

### **BUG 2: New note not visible until page is refetched**

**Issue:** After creating and saving a new note, it does not appear in the note list until the user manually triggers a refetch of the page.

**Root Cause (`reason of triggering the bug report file`):**
The frontend does not use the ID that the backend generates and returns for the new note. Instead of adding the note locally, the app triggers a full refetch of all notes immediately. This creates a race condition where the app might ask for the list of notes before the database has finished saving the new one.

**Solution (Approved):**
This solution provides the best user experience by avoiding a full refresh and the race condition.

1.  **Update API Layer:** Modify `CreateNoteApi.createNote` to parse the JSON response from the server, create a complete `NoteModel` object from it (which will include the new, backend-generated ID), and return this `NoteModel`.
2.  **Update Detail Page:** The `_saveNote` function in `note_detail_page.dart` should receive this new `NoteModel` from the API call and pass the complete object back when it pops the page: `Navigator.of(context).pop(newNoteModel);`.
3.  **Update Home Page (Optimistic Update):** In `note_home_page.dart`, instead of doing a full refetch, the page should receive the new `NoteModel` object and add this single note directly to the local list/state (`NoteBloc`). This provides an instantaneous UI update and allows the app to scroll to the new note.
4.  **As for the backend** it returning like this

**{"data":{"userId":"e95857ba-d18d-4d21-aea2-3b6ab7f32450","title":"dawd","text":"dawdwa","id":"1959a5a0-3c11-4982-a508-b5552b182126","createdAt":"2026-02-03T08:11:31.8077876Z","isDeleted":false},"message":"Note created successfully"}**

---

### **BUG 3: Stuck on detail page when API is unavailable**

**Issue:** If a user tries to save a note while the API is offline, they get stuck on the note detail page. The error snackbar should appear on the home page after being automatically navigated back.

**Root Cause (`reason of triggering the bug report file`):**
The `catch` block in `_saveNote()` shows a `SnackBar` but fails to pop the page, trapping the user. Even if it did pop, the home page has no mechanism to know an error occurred and display its own `SnackBar`.

**Solution (Refined):**
This requires a two-part fix to pass the error state between the pages.

1.  **Signal Failure from Detail Page:** In the `catch` block in `note_detail_page.dart`, remove the `SnackBar` logic. Instead, simply pop the page and pass back a specific error indicator string: `Navigator.of(context).pop('SAVE_FAILED');`.
2.  **Receive Error on Home Page:** In `note_home_page.dart`, the function that handles navigating to the detail page must `await` the result. After the page is popped, it must check if the result is equal to `'SAVE_FAILED'`. If it is, _then_ it should use its own `ScaffoldMessenger` to display the `SnackBar`. It is critical to use the `BuildContext` from the `Scaffold` on the home page to ensure the `SnackBar` can be displayed correctly.
