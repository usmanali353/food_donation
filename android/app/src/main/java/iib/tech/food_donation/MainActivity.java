package iib.tech.food_donation;
import android.view.WindowManager.LayoutParams;
import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;
public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(LayoutParams.FLAG_SECURE);
    }
}
