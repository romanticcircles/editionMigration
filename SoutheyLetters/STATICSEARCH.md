# Regenerating the Southey StaticSearch index

This guide is for editors who receive an updated set of Southey HTML files and
need to regenerate the Project Endings StaticSearch files. No database, web
server software, or custom search program is involved. The build reads the HTML
corpus and creates static JSON, JavaScript, and configuration files that can be
uploaded with the website.

## What is input and what is output?

The source material is the HTML corpus under:

```text
SoutheyLetters/HTML/
```

This includes the nested `Part_One`, `Part_Two`, and other `Part_*` directories,
as well as the paratext pages. StaticSearch scans these directories recursively.

The generated search output is:

```text
SoutheyLetters/HTML/staticSearch/
```

The build also updates these two search pages:

```text
SoutheyLetters/HTML/search.html
SoutheyLetters/HTML/search/index.html
```

The `staticSearch` output contains thousands of small stem JSON files, metadata
filter files, document titles, and the browser-side StaticSearch JavaScript. Do
not edit those generated files by hand. Regenerate them whenever the HTML input
changes.

## One-time setup on Windows

1. Download or clone the complete `editionMigration` repository. Keep the
   `SoutheyLetters` directory and all of its contents together.

2. Install a Java Development Kit (JDK). In PowerShell, confirm Java is
   available:

   ```powershell
   java -version
   ```

3. Obtain Project Endings StaticSearch version 1.4.7. Extract it anywhere on
   the computer. The directory supplied to the build must contain
   StaticSearch's `build.xml` file.

4. Make Apache Ant available in either of these ways:

   - Install Apache Ant and set the Windows `ANT_HOME` environment variable to
     its installation directory; or
   - Use the Ant libraries included with Android Studio. The build script can
     detect the standard Android Studio installation paths automatically.

   The required `ant-contrib` library is already included in this repository at
   `SoutheyLetters/tools/lib/ant-contrib-1.0b3.jar`.

## Preparing updated HTML

Replace or update the source files inside `SoutheyLetters/HTML/`, but preserve
the project directory structure. Do not replace or delete these build files:

```text
SoutheyLetters/config_staticSearch.xml
SoutheyLetters/tools/build_project_endings_static_search.ps1
SoutheyLetters/tools/lib/ant-contrib-1.0b3.jar
```

If replacing the entire `HTML` directory, first save `search.html`, or restore
it from this repository afterward. The old `staticSearch/` output does not need
to be preserved because the build recreates it.

For the search categories and filters to continue working, updated documents
should retain the existing Southey markup, especially:

```html
<div class="letter">...</div>
<div class="notes">...</div>
<div class="paratext">...</div>
<div class="introduction">...</div>
<div class="appendix">...</div>
```

They should also retain the StaticSearch metadata where it applies:

```html
<meta class="staticSearch_docTitle" ... />
<meta class="staticSearch_docAuthor" ... />
<meta class="staticSearch_date" name="Date Written" ... />
<meta class="staticSearch_feat" name="Correspondents" ... />
<meta class="staticSearch_feat" name="People mentioned" ... />
```

If this markup is removed or renamed, the build may finish, but the corresponding
search context or metadata filter will be incomplete.

## Regenerating the index

1. Open PowerShell.

2. Change into the root of the downloaded repository. For example:

   ```powershell
   cd C:\path\to\editionMigration
   ```

3. Run the build, giving it the location of StaticSearch 1.4.7:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\SoutheyLetters\tools\build_project_endings_static_search.ps1 -StaticSearchRoot "C:\path\to\staticSearch-1.4.7"
   ```

   If StaticSearch is stored at the historical project location
   `..\staticseachDocs\staticSearch-1.4.7\staticSearch-1.4.7`, this shorter command
   is sufficient:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\SoutheyLetters\tools\build_project_endings_static_search.ps1
   ```

4. Let the command finish. A full rebuild processes thousands of documents and
   can take significant time. Success is indicated by messages similar to:

   ```text
   BUILD SUCCESSFUL
   StaticSearch build complete.
   Stem JSON files: ...
   Filter JSON files: ...
   ```

The script performs the complete Project Endings build, generates the normal
multi-file output, applies the Windows reserved-filename workaround, and
creates the directory-style `HTML/search/index.html` page.

## Testing the regenerated search locally

From the repository root, start a simple local web server:

```powershell
python -m http.server 8000 --bind 127.0.0.1
```

Leave that PowerShell window open and visit:

<http://127.0.0.1:8000/SoutheyLetters/HTML/search/>

Do not test by double-clicking `index.html`; browsers restrict the local file
requests that StaticSearch needs. The small Python server avoids that problem.

Confirm the following before uploading:

1. Under **Search only in**, exactly **Letters** and **Paratext** appear.
2. Search for a recently added or changed phrase and confirm the expected page
   appears.
3. Confirm the Correspondents, People mentioned, and Date Written controls are
   present when that metadata exists in the corpus.
4. Confirm results appear from more than one nested `Part_*` directory.
5. As a known context test, use letter 125:

   | Term | Context | Expected result |
   | --- | --- | --- |
   | `declamation` | Letters | Letter 125 is found |
   | `declamation` | Paratext | No documents are found |
   | `Aquilon` | Letters | No documents are found |
   | `Aquilon` | Paratext | The notes for letter 125 are found |

Press `Ctrl+C` in PowerShell when local testing is finished.

## Files to upload or copy into another working folder

After a successful build, the main deployable output is the complete directory:

```text
SoutheyLetters/HTML/staticSearch/
```

Keep its internal directory structure unchanged. Also copy or upload the
generated search page used by the site:

```text
SoutheyLetters/HTML/search/index.html
```

If the website links directly to `HTML/search.html`, copy that generated file as
well. An editor may copy these outputs into another local folder or upload them
manually to GitHub; running the build does not require the output to remain in a
Git repository.

Whenever the HTML corpus changes again, repeat the preparation, build, and local
testing steps. The generated index represents a snapshot of the HTML at the
time the build was run.
