import org.kohsuke.github.*;
import java.util.*;

public class test_gh_api {
    public static void main(String[] args) throws Exception {
        String token = System.getenv("GITHUB_TOKEN");
        GitHub github = new GitHubBuilder().withOAuthToken(token).build();
        
        GHRepository repo = github.getRepository("apache/commons-lang");
        
        System.out.println("=== Testing PR extraction ===");
        System.out.println("Repository: " + repo.getFullName());
        System.out.println("Open issues: " + repo.getOpenIssueCount());
        
        // Test getting closed PRs
        PagedIterable<GHPullRequest> closedPRs = repo.getPullRequests(GHIssueState.CLOSED);
        
        int totalClosed = 0;
        int merged = 0;
        int withIssueLink = 0;
        
        for (GHPullRequest pr : closedPRs) {
            totalClosed++;
            
            if (pr.isMerged()) {
                merged++;
                
                String body = pr.getBody();
                if (body != null && (body.contains("#") || body.toLowerCase().contains("fixes") || body.toLowerCase().contains("closes"))) {
                    withIssueLink++;
                    if (withIssueLink <= 3) {
                        System.out.println("\nFound PR #" + pr.getNumber() + " with potential issue link");
                        System.out.println("Body preview: " + (body.length() > 200 ? body.substring(0, 200) + "..." : body));
                    }
                }
            }
            
            if (totalClosed >= 100) break; // Check first 100
        }
        
        System.out.println("\n=== Results ===");
        System.out.println("Closed PRs checked: " + totalClosed);
        System.out.println("Merged PRs: " + merged);
        System.out.println("Merged PRs with issue references: " + withIssueLink);
    }
}
